#!/usr/bin/python
#from scripts.ejtagio import *
from ejtagio import *
def mytest():
 v=inl(0xffffffffbfc00000)
 print hex(v)
 do_cmds(
"""
d4 0xffffffffbfc00000 10
set pc
"""
 )

def getcurpc():
 pcsample=do_cmd1("jtagregs d8q 20 1")
 print "0x%x" % ( (int(pcsample, 0)>>1) & 0xffffffff)

getcurpc()
mytest()

