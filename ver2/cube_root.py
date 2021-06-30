# Adapted, with minor modifications, from stackoverflow:
# https://stackoverflow.com/questions/6752374/cube-root-modulo-p-how-do-i-do-this
# did not test fully, but it works for the NTTRU parameters we're using


def tonelli3(a,p,many=False):

    def solution(p,root):
        g=p-2
        while pow(g,(p-1)//3,p)==1: g-=1  #Non-trivial solution of x**3=1
        g=pow(g,(p-1)//3,p)
        return sorted([root%p,(root*g)%p,(root*g**2)%p])

    #---MAIN---
    a=a%p
    if p in [2,3] or a==0: return a 
    if p%3 == 2: return pow(a,(2*p - 1)//3, p) #One solution

    #No solution
    if pow(a,(p-1)//3,p)>1: return []

    #p-1=3**s*t
    s=0
    t=p-1
    while t%3==0: s+=1; t//=3
    
    #Cubic nonresidu b
    b=p-2
    while pow(b,(p-1)//3,p)==1: b-=1

    c,r=pow(b,t,p),pow(a,t,p)    
    c1,h=pow(c,3**(s-1),p),1    
    c=pow(c,p-2,p) #c=inverse modulo p

    for i in range(1,s):
        d=pow(r,3**(s-i-1),p)
        if d==c1: h,r=h*c,r*pow(c,3,p)
        elif d!=1: h,r=h*pow(c,2,p),r*pow(c,6,p)           
        c=pow(c,3,p)
        
    if (t-1)%3==0: k=(t-1)//3
    else: k=(t+1)//3

    r=pow(a,k,p)*h
    if (t-1)%3==0: r=pow(r,p-2,p) #r=inverse modulo p

    if pow(r,3,p)==a: 
        if many: 
            return solution(p,r)
        else: return r % p
    else: return [] 

#assumes p prime, it returns all cube roots of a mod p
def cuberoots(a, p):

    #Non-trivial solutions of x**r=1
    def onemod(p,r):
        sols=set()
        t=p-2
        while len(sols)<r:        
            g=pow(t,(p-1)//r,p)
            while g==1: t-=1; g=pow(t,(p-1)//r,p)
            sols.update({g%p,pow(g,2,p),pow(g,3,p)})
            t-=1
        return sols

    def solutions(p,r,root,a): 
        todo=onemod(p,r)
        return sorted({(h*root)%p for h in todo if pow(h*root,3,p)==a})[0]

    #---MAIN---
    a=a%p

    if p in [2,3] or a==0: return [a]
    if p%3 == 2: return [pow(a,(2*p - 1)//3, p)] #One solution

    #There are three or no solutions 

    #No solution
    if pow(a,(p-1)//3,p)>1: return []

    if p%9 == 7:                                #[7, 43, 61, 79, 97, 151]   
        root = pow(a,(p + 2)//9, p)
        if pow(root,3,p) == a: return solutions(p,3,root,a)
        else: return []

    if p%9 == 4:                                #[13, 31, 67, 103, 139]
        root = pow(a,(2*p + 1)//9, p) 
        #print(root)
        if pow(root,3,p) == a: return solutions(p,3,root,a)        
        else: return []        
                
    if p%27 == 19:                              #[19, 73, 127, 181]
        root = pow(a,(p + 8)//27, p)
        return solutions(p,9,root,a)

    if p%27 == 10:                              #[37, 199, 307]
        root = pow(a,(2*p +7)//27, p)  
        return solutions(p,9,root,a) 

    #We need a solution for the remaining cases
    return tonelli3(a,p,False)
