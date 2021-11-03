import sys;
import struct;
f1 = len(sys.argv)>2 and open(sys.argv[2],"wb") or sys.stdout
f = open(sys.argv[1] if len(sys.argv)>1 else  "/tmp/1.txt","rb")
log_first_idx =  len(sys.argv)>3 and int(sys.argv[3],0) or 0
log_next_idx =  len(sys.argv)>4 and int(sys.argv[4],0) or -1
idx=log_first_idx
goback=0
f1.write(str(sys.argv)+"\n")
while 1:
            f.seek(idx)
            b=f.read(16) or exit(0)
            t,alen,tlen,dlen,fac,flag  = struct.unpack('=QHHHBB',b)
            if alen:
              m=f.read(tlen)
              txt=m.decode('utf8','ignore')
              f1.write(("%f:%s\n" %(t/1000000000.0, txt)).encode('utf8'))
              idx=idx+alen
            else:
              if goback:
                break
              idx = 0
              goback=1
            if idx == log_next_idx:
              break
