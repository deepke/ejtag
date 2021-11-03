import struct
f=open('/tmp/3.txt','rb')
while 1:
 buf=f.read(16)
 t,alen,tlen,dlen,fac,flag  = struct.unpack('=QHHHBB',buf)
 all = f.read(alen-16)
 txt = all[:tlen]
 print("%d :%s" %(t, txt))

