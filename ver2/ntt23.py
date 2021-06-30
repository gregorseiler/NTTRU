import numpy as np
import time
import sympy as sp
#from gmpy import invert # thought this would help with modular inverse.  maybe too much conversion is ruining the effect

from mod_sqrt import modular_sqrt
from cube_root import cuberoots


def mod_invert(a,p):
	# modular inverse.  if there is no inverse, should return 0
	return pow(a,p-2,p)

def evaluate(a,r,p):
	#a simple evaluation function a(r)mod p to test the ntt routine
	fin=0
	for i in range(len(a)-1,-1,-1):
		fin=(fin*r+a[i]) % p
	return fin

def polmod(a,deg,const,p):
	# a modular reduction of polynomial a modulo X^deg-const and p
	# used for testing
	res=np.int64(np.zeros(deg))
	for i in range(0,len(a)):
		res[i % deg]=res[i % deg]+pow(const,i//deg,p)*a[i] % p
	return res % p

def multdeg2(pol1,pol2,r,p):
	# multiplication of two polynomials modulo X^2-r
	res=[]
	res.append(pol1[0]*pol2[0]+pol1[1]*pol2[1]*r % p)
	res.append(pol1[0]*pol2[1]+pol1[1]*pol2[0] % p)
	return res

def multdeg3(a,b,r,p):
	# multiplication of two polynomials modulo X^3-r
	res=[]
	res.append(a[0]*b[0]+(a[1]*b[2]+a[2]*b[1])*r %p )
	res.append(a[0]*b[1]+a[1]*b[0]+a[2]*b[2]*r % p)
	res.append(a[0]*b[2]+a[2]*b[0]+a[1]*b[1] % p)
	return res

def invdeg2(pol,r,p):
	# inverse of a polynomial modulo X^2-r
	# returns 0 if there is no inverse
	detinv=mod_invert(int(pol[0]*pol[0]-pol[1]*pol[1]*r),p)
	return [pol[0]*detinv %p,-pol[1]*detinv % p]

def invdeg3(a,r,p):
	# inverse of a polynomial modulo X^3-r
	# returns 0 if there is no inverse
	a0sq=a[0]*a[0] 
	a1sq=a[1]*a[1] 
	a2r=a[2]*r 
	a2sqr=a2r*a[2] %p
	a1a2r=a[1]*a2r %p
	detinv=mod_invert(int(a[0]*a0sq+r*a[1]*a1sq+a2r*a2sqr-3*a[0]*a1a2r %p),p)
	return [(a0sq-a1a2r)*detinv % p, (a2sqr-a[0]*a[1])*detinv % p, (a1sq-a[0]*a[2])*detinv % p]

def nttmult1(pol1,pol2,p):
	# multiplications of polynomials in NTT form.  the bottom row is Zp
	return np.multiply(pol1,pol2) % p

def nttinv1(pol,p):
	# inversion of polynomials in NTT form. the bottom row is Zp
	res=[]
	for i in range(0,len(pol)):
		res.append(mod_invert(int(pol[i]),p))
	return res

def nttmult2(pol1,pol2,roots,p):
	# multiplications of polynomials in NTT form.  the bottom row is mod X^2-roots[.]
	res=np.int64(np.zeros(len(pol1)))
	for i in range(0,len(res)//2):
		res[2*i:2*i+2]=multdeg2(pol1[2*i:2*i+2],pol2[2*i:2*i+2],roots[i],p)
	return res % p

def nttinv2(pol,roots,p):
	# inversion of polynomials in NTT form.  the bottom row is mod X^2-roots[.]
	res=np.int64(np.zeros(len(pol)))
	for i in range(0,len(res)//2):
		res[2*i:2*i+2]=invdeg2(pol[2*i:2*i+2],roots[i],p)
	return res % p

def nttinv3(pol,roots,p):
	# inversion of polynomials in NTT form.  the bottom row is mod X^3-roots[.]
	res=np.int64(np.zeros(len(pol)))
	for i in range(0,len(res)//3):
		res[3*i:3*i+3]=invdeg3(pol[3*i:3*i+3],roots[i],p)
	return res % p

def nttmult3(pol1,pol2,roots,p):
	# multiplications of polynomials in NTT form.  the bottom row is mod X^3-roots[.]
	res=np.int64(np.zeros(len(pol1)))
	for i in range(0,len(res)//3):
		res[3*i:3*i+3]=multdeg3(pol1[3*i:3*i+3],pol2[3*i:3*i+3],roots[i],p)
	return res % p

def ntthaszero(pol,botdeg):
	# check if some NTT coefficient, where the bottom row is mod X^botdeg - r is 0
	# needed for inversion
	i=0
	while i<len(pol):
		if (pol[i:i+botdeg]==np.zeros(botdeg)).all():
			return True
		i+=botdeg
	return False

def constc(specs):
	

	# creates the factorization tree of f(X)=X^n-X^n/2+1
	#only includes one root r on each level.
	# the first level has the root prim3+1 (the non-included root is -prim3)
	# the next levels are square roots r ( the non-included root is -r)
	# after square roots are finished, come the cube roots.  r is enclosed (prim3*r, prim3^2*r is not)
	p=specs[0]
	halfings=specs[1]
	thirdings=specs[2]
	prim3=specs[3]

	roots=[[]]
	last_is_halfing=True # indicator that the previous line consists of r and -r
	# the first factorization is X^n-X^n/2+1 = (X^n/2-(prim3+1))(X^n/2+prim3)
	roots[0].append(prim3+1)
	roots.append([]) # create new row
	if halfings > 0: # need to take a square root
		roots[1].append(modular_sqrt(int(prim3+1),p))
		roots[1].append(modular_sqrt(-int(prim3),p))
		halfings-=1 
	else: # otherwise take a third root.  we assume that f(x) doesn't just factor once
		roots[1].append(cuberoots(int(prim3+1),p))
		roots[1].append(cuberoots(-int(prim3),p))
		thirdings-=1
		last_is_halfing=False
	i=2 # next row number
	while halfings>0: # we will be taking square roots
		roots.append([])
		for j in roots[i-1]:
			roots[i].append(modular_sqrt(int(j),p))
			roots[i].append(modular_sqrt(-int(j),p))
		halfings-=1
		i+=1
	while thirdings>0: # now taking 3rd roots
		roots.append([])
		for j in roots[i-1]:
			if last_is_halfing: # the previous line contains roots r, and implicitly -r
				roots[i].append(cuberoots(int(j),p))
				roots[i].append(cuberoots(-int(j),p))
			else: # the previous line consists of roots r and, implicitly, multiples by prim3 and prim3^2
				roots[i].append(cuberoots(int(j),p))
				roots[i].append(cuberoots(int(j*prim3 % p),p))
				roots[i].append(cuberoots(int(j*prim3*prim3 % p),p))
		thirdings-=1
		i+=1
		last_is_halfing=False # a thirding just occured
	
	#create a list of all the roots.  needed for multiplication if the final degree is more than 1
	all_last_roots=[]

	for i in roots[len(roots)-1]:
		if last_is_halfing: # the last line contains roots r and, implicitly, -r
			all_last_roots.append(i)
			all_last_roots.append(-i)
		else: # the last line contains roots r and, implicitly, r*prim3, r*prim3^2
			all_last_roots.append(i)
			all_last_roots.append(i*prim3 % p)
			all_last_roots.append(i*prim3**2 % p)
	
	return roots, all_last_roots

def invconstc(roots,p):
	# creates the inverses of the factorization tree.  used for the inverse NTT
	invroots=[]
	for row in roots:
		invrow=[mod_invert(j,p) for j in row]
		invroots.append(invrow)
	invroots[0][0]=(mod_invert(2*roots[0][0]-1,p)) # we'll need the inverse of (2r-1) instead of r
	return invroots
	
def nttgen(a,roots,specs):
	def modchalf(c,clen):
		newlen=lena//clen
		hlen=newlen//2
		for i in range(0,clen):
			temp=np.zeros(newlen)
			azero=newlen*i
			temp2=c[i]*a[azero+hlen:azero+newlen]
			temp[0:hlen]=(a[azero:azero+hlen]+ temp2) % p
			temp[hlen:newlen]=(a[azero:azero+hlen]- temp2) % p
			a[azero:azero+newlen]=temp % p
	
	def modcthird(c,clen):
		newlen=lena//clen
		tlen=newlen//3
		tlen2=2*tlen
		for i in range(0,clen):
			azero=newlen*i # starting position of the polynomial f we're modding
			# f=f0+f1X+f2X^2.  f mod X - r = f0+f1r+f2r^2
			# f mod X- tr = f0+f1tr+f2t^2r^2.  f mod t^2r = f0+f1t^2r+f2tr^2
			f1r=c[i]*a[azero+tlen:azero+tlen2] % p # f1*r
			f2r2=c[i]*c[i]*a[azero+tlen2:azero+newlen] % p #f2*r^2
			# can save one multiplication in the above by also precomputing r^2
			f1tr=f1r*prim3 # f1tr = f1*r*t
			f2tr2=f2r2*prim3  # f2tr^2 = f2r^2*prim3
			f1t2r=-f1r-f1tr # f1t^2r = -f1r - f1tr
			f2t2r2=-f2r2-f2tr2 # f2t^2r^2 = - f2r^2 - f2r^2 - f2tr^2
			f0=np.copy(a[azero:azero+tlen])
			a[azero:azero+tlen]=f0+f1r+f2r2 % p # new value of f0
			a[azero+tlen:azero+tlen2]=f0+f1tr+f2t2r2 % p # new value of f1
			a[azero+tlen2:azero+newlen]=f0+f1t2r+f2tr2 % p # new value of f2

	p=specs[0]
	halfings=specs[1]
	thirdings=specs[2]
	prim3=specs[3]

	lena=len(a)
	hlena=lena//2
	# reducing BX+A mod (X-r) and (X+(r-1))
	temp=roots[0][0]*a[hlena:lena] # r*B
	a[hlena:lena]=a[0:hlena]-temp+a[hlena:lena] # BX+A mod X+(r-1)= A-r*B+B
	a[0:hlena]=a[0:hlena]+temp # BX+A mod X-r = r*B+A
	clen=2 # number of polynomials stored in a
	for i in range(1,halfings+1):
		c=roots[i]
		modchalf(c,clen)
		clen*=2
	for i in range(halfings+1,halfings+1+thirdings):
		c=roots[i]
		modcthird(c,clen)
		clen*=3
	return a % p

def inttgen(a,invroots,specs):
	def invmodchalf(c,clen):
		newlen=lena//clen
		hlen=newlen//2
		for i in range(0,clen):
			azero=newlen*i
			temp=a[azero:azero+hlen]+a[azero+hlen:azero+newlen]
			a[azero+hlen:azero+newlen]=(a[azero:azero+hlen]-a[azero+hlen:azero+newlen])*c[i] % p
			a[azero:azero+hlen]=np.copy(temp)
	
	def invmodcthird(c,clen):
		newlen=lena//clen
		tlen=newlen//3
		tlen2=2*tlen
		for i in range (0,clen):
			temp=np.zeros(newlen)
			azero=newlen*i
			temp[0:tlen]=a[azero:azero+tlen]+a[azero+tlen:azero+tlen2]+a[azero+tlen2:azero+newlen]
			temp[tlen:tlen2]=c[i]*(a[azero:azero+tlen]+prim32*a[azero+tlen:azero+tlen2]+prim3*a[azero+tlen2:azero+newlen])%p
			temp[tlen2:newlen]=c[i]*c[i]*(a[azero:azero+tlen]+prim3*a[azero+tlen:azero+tlen2]+prim32*a[azero+tlen2:azero+newlen])%p
			a[azero:azero+newlen]=np.copy(temp)

	p=specs[0]
	halfings=specs[1]
	thirdings=specs[2]
	prim3=specs[3]
	botdegree=specs[5]

	lena=len(a)
	prim32=-1-prim3 # prim3^2=-1 - prim3
	twoinv=(p+1)//2 
	threeinv=-(p-1)//3 # assumes that p = 1 (mod 3)
	clen=lena//botdegree # number of polynomials stored in a
	for i in range(halfings+thirdings,halfings,-1):
		c=invroots[i]
		invmodcthird(c,clen//3)
		clen=clen//3
	for i in range(halfings,0,-1):
		c=invroots[i]
		invmodchalf(c,clen//2)
		clen=clen//2

	a=(twoinv**halfings % p)*(threeinv**thirdings % p)*a
	temp=(a[0:lena//2]-a[lena//2:lena])*invroots[0][0] % p
	a[0:lena//2]=(a[0:lena//2]+a[lena//2:lena]-temp)*twoinv % p
	a[lena//2:lena]=temp
	return a % p

def multnttntt(pol1ntt,pol2ntt,all_roots,specs):
	# multiplication of polynomials in ntt form
	p=specs[0]
	bot_deg=specs[5]
	if bot_deg==1:
		return nttmult1(pol1ntt,pol2ntt,p)
	elif bot_deg==2:
		return nttmult2(pol1ntt,pol2ntt,all_roots,p)
	elif bot_deg==3:
		return nttmult3(pol1ntt,pol2ntt,all_roots,p)
	else:
		print('not yet supported')
		return 0	

def multnttpol(pol1ntt,pol2,root_tree,all_roots,specs):
	# multiplication of one polynomial in ntt with a polynomial in coefficient rep
	pol2=nttgen(pol2,root_tree,specs)
	return multnttntt(pol1ntt,pol2,all_roots,specs)

def invntt(pol,all_roots,specs):
	# inverse of a polynomial in ntt form.  if no inverse, will return empty list
	p=specs[0]
	bot_deg=specs[5]
	#if ntthaszero(pol,bot_deg):
		# print('not invertible')
	#	return []
	if bot_deg==1:
		temp=np.int64(nttinv1(pol,p))
		if ntthaszero(temp,bot_deg): # if pol is not invertible, trying to invert it will produce a 0 in the NTT position which is not invertible
			# print('not invertible')
			return []
		return temp
	elif bot_deg==2:
		temp=np.int64(nttinv2(pol,all_roots,p))
		if ntthaszero(temp,bot_deg): # if pol is not invertible, trying to invert it will produce a 0 in the NTT position which is not invertible
			# print('not invertible')
			return []
		else:
			return temp
	elif bot_deg==3:
		temp=np.int64(nttinv3(pol,all_roots,p))
		if ntthaszero(temp,bot_deg): # if pol is not invertible, trying to invert it will produce a 0 in the NTT position which is not invertible
			# print('not invertible')
			return []
		else:
			return temp

# def invpol(pol,root_tree,all_roots,specs):
# 	p=specs[0]
# 	bot_deg=specs[5]
# 	pol=nttgen(pol.copy(),root_tree,specs)
# 	return invntt(pol,all_roots,specs)


if __name__ == '__main__':
	data5762593=[2593,4,2,1137,576,2]
	data5763457=[3457,5,2,722,576,1]
	data6482917=[2917,1,4,247,648,2]
	data7683457=[3457,6,1,722,768,2]
	data9723889=[3889,1,4,1890,972,3]
	# add X^12-X^6+1 mod 37
	data1237=[37,1,1,10,12,1]
	data2437=[37,1,1,10,24,2]
	data1213=[13,1,0,3,12,3]
	datalist=[data5762593,data5763457,data6482917,data7683457,data9723889,data1237,data2437,data1213]

	data=datalist[7]
	p=data[0]
	halfings=data[1]
	thirdings=data[2]
	prim3=data[3]
	botdeg=data[5]
	tr,all_last_roots=constc(data)
	# print(tr)
	invroots=invconstc(tr,p)
	n=data[4]
	a=np.int64(np.ones(n))
	a[0]=1
	a[1]=1
	a[2]=1
	print(a)
	b=a.copy()
	a=nttgen(a,tr,data)
	a=invntt(a,all_last_roots,data)
	a=invntt(a,all_last_roots,data)
	a=inttgen(a,invroots,data)
	print(a)
	a=multnttpol(a,b,tr,all_last_roots,data)
	print('id?',a)

	idpol=np.int64(np.zeros(n))
	idpol[0]=1
	#a[0]=2
	#a[1]=5
	#a[3]=-11
	print(nttgen(a.copy(),tr,data))
	#print('ANY ZERO????', ntthaszero(ntta,botdeg))
	#ntinv=nttinv2(ntta,all_last_roots,p)
	ntinv=invpol(a.copy(),tr,all_last_roots,data)
	print(ntinv)
	#ntinv=multnttpol(ntinv,idpol,tr,all_last_roots,data)
	#print(ntinv)
	ntinv2=inttgen(ntinv.copy(),invroots,data)
	print(ntinv2)
	#ntres=multnttntt(ntta,ntinv,all_last_roots,data)
	ntres2=multnttpol(ntinv,a,tr,all_last_roots,data)
	aprime=inttgen(ntres2,invroots,data)
	print('IDENTITY???', aprime)
	
	#print(nttmult2(ntta,ntta,all_last_roots,p))
	#print(a %p)
	print('got here')
	#aprime=inttgen(ntta,invroots,data)
	#print(ntta % p)
	#pri
