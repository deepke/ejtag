import re;
import sys;
dc={}
sc={}
f=open("cachedump.txt" if len(sys.argv)==1 else sys.argv[1],"rb")
l = f.readline()
while l:
  if l.startswith("cs="):
   m=re.search("cs=(?P<cs>\S+) phy=(?P<phy>\S+) way=(?P<way>\S+) w=(?P<w>\S+) scway=(?P<scway>\S+) taglo=(?P<taglo>\S+) taghi=(?P<taghi>\S+)",l)
   if m:
      d=m.groupdict()
      m = map( (lambda x:int(x,0)), m.groups())
      if m[0] != 0:
        if m[1] in dc:
          print("error %#x %s" %(m[0],str(d)))
        m.append(d)
        dc[m[1]] = m
  elif l.startswith("ss=") or l.startswith("s="):
   m=re.search("s=(\d) phy=(\S+) way=(\d) pkg=(\d) kp=(\d) w=(\d) ds=(\d) taglo=(\S+) taghi=(\S+)", l)
   if m:
      m = map( (lambda x:int(x,0)), m.groups())
      if m[0] == 1:
        sc[m[1]] = m
  l = f.readline()

for i in dc:
 if i not in sc:
    print("0x%08x not in scache, %s" % (i, str(dc[i][7])))
 else :
    if sc[i][2] != dc[i][4]:
       print("dc,sc %#x way %d != %d" %(i, dc[i][4], sc[i][2]))
