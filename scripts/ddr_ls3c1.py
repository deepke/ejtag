import re
import sys
import struct

f=open('gzrom-ls3a3000-kunlun.bin' if len(sys.argv)==1 else sys.argv[1])
f.seek(54048)
d=struct.unpack('%dQ'%(0x370/8),f.read(0x370))
dr=struct.unpack('%dQ'%(0x370/8),f.read(0x370))

lable = 'MC0_DDR3_CTRL_0x'
labler = 'MC0_DDR3_RDIMM_CTRL_0x'

f=open('loongson_mc2_param.S');
l =f.readline()
while l:
 if re.match(lable,l):
  l=re.sub(lable+'([^:]+):\s+.dword\s+(\S+)', lambda x: lable+ x.groups()[0] + ': .dword 0x%016x' % d[int(x.groups()[0],16)/8], l)
 elif re.match(labler,l):
  l=re.sub(labler+'([^:]+):\s+.dword\s+(\S+)', lambda x: labler+ x.groups()[0] + ': .dword 0x%016x' % dr[int(x.groups()[0],16)/8], l)
 sys.stdout.write(l)
 l =f.readline()
  

