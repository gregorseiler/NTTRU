import hashlib
import numpy as np
import time
from ntt23 import multnttpol, multnttntt, invntt, inttgen, nttgen, constc, invconstc

t1=time.time()
# data for each parameter set
# [prime,square roots in ntt, cube roots in ntt, 3rd primitive root of unity, degree, degree of bottom ntt]
data5762593=[2593,4,2,1137,576,2] # log(err) = -152, pk/ct = 864B, 133 core-svp
data5763457=[3457,5,1,722,576,3] # log(err) = -260, pk/ct = 864B, 128 core-svp. Can also split as [3457,5,2,722,576,1], but it's slower. [3457,4,2,722,576,2] is faster.  [3457,5,1,722,576,3] is fastest  
data6482917=[2917,1,4,247,648,2] # log(err) = -172, pk/ct = 972B, 152 core-svp
data7683457=[3457,6,1,722,768,2] # log(err) = -206, pk/ct = 1152B, 181 core-svp
data9723889=[3889,1,4,1890,972,3] # log(err) = -210, pk/ct = 1458B, 236 corse-svp
# debugging parameters
data1237=[37,1,1,10,12,1]
data2437=[37,1,1,10,24,2]
data12181=[181,1,1,48,12,1]
datalist=[data5762593,data5763457,data6482917,data7683457,data9723889,data1237,data2437,data12181]

data=datalist[1] # change the number to set different parameters

Q=data[0] # prime
DEG=data[4] # degree
BOT_DEG=data[5] # degree of bottom ntt (elementary operations performed over those)
ROOT_TREE, ALL_BOTTOM_ROOTS = constc(data) # create tree for ntts and expand all roots at the bottom
INV_TREE=invconstc(ROOT_TREE,Q) # create the tree for doing inverse ntts

GLOBAL_COUNTER = 0  # seed for the global PRF that is being used. every call to randombytes(num) increments this value by 1
print('setup time', time.time()-t1)

# uses the current value of GLOBAL_COUNTER as a 32-byte input to shake_128, 
# outputs num bytes, and then increments the GLOBAL_COUNTER by 1
def randombytes(num):
    global GLOBAL_COUNTER
    seed = GLOBAL_COUNTER
    blist = []
    for i in range(0, 8):
        blist.append(seed % 256)
        seed = seed // 256
    GLOBAL_COUNTER += 1
    return hashlib.shake_128(bytes(blist)).digest(num)

# covert a byte to 8 bits
def byte_to_bits(b):
    bitar=[]
    for j in range(8): # convert the byte b to 8 bits
        bitar.append(b % 2)
        b=b // 2
    return bitar

# convert 8 bits to a byte
def bits_to_byte(bitar):
    temp=0
    pow2=1
    for j in range(8):
        temp+=pow2*bitar[j]
        pow2*=2
    return temp

# packing a polynomial with DEG coefficients each having 12 bits
def pack_poly(h):
    # pack two 12-bit coefficients in 3 bytes
    packed=[]
    for i in range(DEG//2):
        temp=h[2*i]%256
        temp2=h[2*i+1]%16
        packed.append(temp)
        packed.append((h[2*i]-temp)//256 + 16*(temp2))
        packed.append((h[2*i+1]-temp2)//16)
    return packed

# reverse of the packing operation
def unpack_poly(packed):
    h=[]
    for i in range(DEG//2):
        temp=packed[3*i+1]%16
        h.append(packed[3*i]+256*temp)
        h.append((packed[3*i+1]-temp)//16 + 16*packed[3*i+2])        
    return np.int64(h)

# creates random polynomial according to the bin(2) distribution
# if byte_ar is given, it uses it.  otherwise creates a random byte_ar
def gen_rand_poly(byte_ar=[]):
    if len(byte_ar)==0:
        byte_ar=randombytes(DEG // 2) # need DEG/2 bytes to create one polynomial
    pol_ZZ=[] # a list that will consist of DEG coefficients of a polynomial
    for i in range(DEG // 2):
        bitar=byte_to_bits(byte_ar[i])
        pol_ZZ.append(bitar[0]+bitar[1]-bitar[2]-bitar[3]) # convert first half byte to one coefficient
        pol_ZZ.append(bitar[4]+bitar[5]-bitar[6]-bitar[7]) # convert second half of byte to second coeff
    return np.int64(pol_ZZ)

def center_mod(y, m):
    z1 = y % m  # positive value of y mod m
    z2 = z1 - m  # negative value of y mod m
    inds = abs(z2) < z1  # boolean vector over indices in which the magnitude
                         # of the negative value is smaller
    return inds*z2 + (1-inds)*z1  # return the smaller magnitude out of each list

def KeyGen():
    f=gen_rand_poly() # generate random f
    f=2*f
    g_has_inverse=False
    while g_has_inverse==False:
        g=gen_rand_poly() # generate random g'
        g=2*g # multiply g' by 2
        g[0]=g[0]+1 # g = 2*g'+1
        g=nttgen(g,ROOT_TREE,data) # compute ntt of g.  this is the secret key
        ginv=invntt(g,ALL_BOTTOM_ROOTS,data) # inverse of g (g is in ntt notation)
        if len(ginv) > 0: # if g has no inverse mod Q, the function will return an empty list []
            g_has_inverse=True
    h=multnttpol(ginv,f,ROOT_TREE,ALL_BOTTOM_ROOTS,data) # h=2*f/g
    return g,h # secret key g and public key h

def CPA_Encrypt(h,m,r=[]):
    if len(r)==0: # no randomness was passed in
        r=gen_rand_poly() # create randomness r
    c=multnttpol(h,r,ROOT_TREE,ALL_BOTTOM_ROOTS,data) #c=h*r
    m=nttgen(m,ROOT_TREE,data)
    c=(c+m) % Q # c=h*r+m, in ntt rep.
    return c

def CPA_Decrypt(c,g):
    temp=multnttntt(c,g,ALL_BOTTOM_ROOTS,data) # c*g mod Q in ntt form
    temp=inttgen(temp,INV_TREE,data) # polynomial representation of c*g
    temp=center_mod(temp,Q) # center the distribution between -Q/2 and Q/2
    msg2=temp%2 # reduce modulo 2 to recover msg mod 2
    return msg2

def expand_m0(hp,m0seed):
    # use the 32 byte seed m0 to produce the shared key, the randomness r used in encryption and the 
    # 'error' m used in encryption.  m should have the property that its first 256 positions modulo 2
    # are equal to the positions of m0seed, when the latter is expanded as a 256-bit string 
    for i in range(0,48,1):
        m0seed.append(hp[i]) # append first 48 positions of packed public key mod 256 to the msg 
    full_hash=hashlib.shake_128(bytes(m0seed)).digest(DEG+32) # create H(msg,id(pk))
    shared_key=full_hash[0:32] # first 32 bytes is the shared key
    rseed=full_hash[32:32+DEG//2] # next DEG//2 bytes makes the randomness
    r=gen_rand_poly(rseed) # create a randomness polynomial
    mseed=full_hash[32+DEG//2:32+DEG] # next DEG//2 bytes creates the message
    m=[] # the message
    # creating the first 256 positions of m such that mod 2 they are the 256 bits of m0seed
    # first, putting each bit of m0 into m
    for i in range(32):
        bitar=byte_to_bits(m0seed[i])
        m.extend(bitar)
    # next, supplementing the first bit with the correct distribution.  one byte is used to create two coefficients
    # this distribution should be the same as in gen_rand_poly()
    for i in range(128):
        bitar=byte_to_bits(mseed[i])
        m[2*i]=(m[2*i]-2*bitar[0]*bitar[1])*(1-2*bitar[2])
        m[2*i+1]=(m[2*i+1]-2*bitar[3]*bitar[4])*(1-2*bitar[5])
    # the rest of the positions are generated normally as b0+b1-b2-b3    
    for i in range(128,DEG//2):
        bitar=byte_to_bits(mseed[i])
        m.append(bitar[0]+bitar[1]-bitar[2]-bitar[3]) # convert first half byte to one coefficient
        m.append(bitar[4]+bitar[5]-bitar[6]-bitar[7]) # convert second half of byte to second coeff
    return shared_key,np.int64(r),np.int64(m)
        
def CCA_Encaps(hp,m0seed=0):
    if m0seed == 0: # in decapsulation, re-encryption uses the recovered m0seed
        m0seed=list(randombytes(32))
    shared_key,r,m = expand_m0(hp,m0seed) # creates the shared key, message and randomness
    h=unpack_poly(hp) 
    c=CPA_Encrypt(h,m,r) # encrypt c in ntt representation
    return shared_key, pack_poly(c)

def CCA_Decaps(cp,gp,hp):
    c=unpack_poly(cp)
    g=unpack_poly(gp)
    m0=CPA_Decrypt(c,g)
    m0seed=[]
    # convert first 256 bits of m0 to a 32 byte string
    for i in range(32):
        m0seed.append(bits_to_byte(m0[8*i:8*i+8]))
    shared_key, c2p=CCA_Encaps(hp,m0seed) # re-encrypt with m0seed
    if not cp==c2p: # check that re-encryption equals the plaintext
        print('decryption fail')
        return []
    return shared_key
    
cparuns=100
ccaruns=100
tkeygen=0
tencrypt=0
tdecrypt=0
print(data)
for j in range(cparuns):
    temp=time.time()
    g,h = KeyGen()
    tkeygen+=(time.time()-temp)
    temp=time.time()
    m=gen_rand_poly()
    mmod2=m%2
    c=CPA_Encrypt(h,m.copy())
    tencrypt+=(time.time()-temp)
    temp=time.time()
    mget=CPA_Decrypt(c,g)
    tdecrypt+=(time.time()-temp)
    if not (mget == mmod2).all():
        print(m)
        print(mmod2)
        print(mget)
        break
print('CPA Runs: ', cparuns, 'Keygen: ',tkeygen, 'Encrypt: ',tencrypt, 'Decrypt: ',tdecrypt)

tkeygen=0
tencrypt=0
tdecrypt=0
for j in range(ccaruns):
    temp=time.time()
    g,h = KeyGen()
    hp=pack_poly(h)
    gp=pack_poly(g)
    tkeygen+=(time.time()-temp)
    temp=time.time()
    shared_key, cp = CCA_Encaps(hp)
    tencrypt+=(time.time()-temp)
    temp=time.time()
    k2 = CCA_Decaps(cp,gp,hp)
    tdecrypt+=(time.time()-temp)
print('CCA Runs: ', ccaruns, 'Keygen: ',tkeygen, 'Encrypt: ',tencrypt, 'Decrypt: ',tdecrypt)    
