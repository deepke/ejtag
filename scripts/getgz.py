#!/usr/bin/python
import sys
import gzip
import StringIO
import tempfile
#import getopt
import lzma
import importlib
tmpdir=None

#opt,argv=getopt.getopt(sys.argv[1:],'b:o:s:f:w')
#opt=dict(opt)
#    if opt.has_key('-w'):

def trygzip():
 global tmpdir
 f=open(len(sys.argv)>1 and sys.argv[1] or 'vmlinux','rb')
 m=f.read()
 f.close()
 i=0
 got = 0;
 while i<len(m):
  i=m.find('\x1f\x8b\x08',i)
  if i<0 : break
  gz=gzip.GzipFile(fileobj=StringIO.StringIO(m[i:]))
  try:
   buf=''
   buf=gz.read()
  except Exception,e:
   pass
  finally:
   if buf or gz.extrasize:
    got = 1
    if not tmpdir:
      tmpdir = tempfile.mkdtemp()+'/'
    fname=tmpdir+str(i)+'-'+str(gz.extrasize+len(buf))
    print(fname)
    f=open(fname,'wb')
    if buf:
      f.write(buf)
    if gz.extrasize:
      f.write(gz.extrabuf)
    f.close()
 
    i+=gz.fileobj.tell()
   else :
    i+=3
 return got
 
def trydecomp(module, hlen=4, head=''):
 gz=importlib.import_module(module)
 global tmpdir
 f=open(len(sys.argv)>1 and sys.argv[1] or 'vmlinux','rb')
 m=f.read()
 f.close()
 if not head:
  head=gz.compress('')[:hlen]
 got = 0
 i=0
 while i<len(m):
  i=m.find(head,i)
  if i<0 : break
  try:
   buf=''
   buf=gz.decompress(m[i:])
  except Exception,e:
   pass
  finally:
   if buf:
    got = 1
    if not tmpdir:
      tmpdir = tempfile.mkdtemp()+'/'
    fname=tmpdir+str(i)+'-'+str(len(buf))
    print(fname)
    f=open(fname,'wb')
    if buf:
      f.write(buf)
    f.close()
 
    i+=len(head)
   else :
    i+=len(head)
 return got

def trybz2():
 import bz2
  


trygzip() or trydecomp('bz2') or trydecomp('lzma',4,'\x5d\x00\x00\x80') or trydecomp('lz4',4,'\x89LZO')
