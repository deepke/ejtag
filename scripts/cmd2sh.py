#!/usr/bin/python
import tempfile
import os
import re
import sys
import struct

def testre(m,v):
    v[0]=m
    return m

m=[0]
f=open(sys.argv[1],'rb')
l = f.readline()
while l:
 l=re.sub('{','$((', l)
 l=re.sub('}','))', l)
 if testre(re.match('\s*function\s+(\S+)\s*', l), m):
  print(m[0].groups()[0] + "()\n{")
 elif testre(re.match('\s*ret[\s;$]', l), m):
  print('}')
 elif testre(re.match('\s*let[l]*\s', l), m):
  if l.find('(')>=0 :
   sys.stdout.write(l)
  else :
   a=re.split('\s+',l.strip().rstrip())
   s=''
   n=(len(a)-1)/2
   for i in range(n):
     s += a[i+1] + '=' + a[i+1+n] + ' '
   print(s)
 elif testre(re.match('\s*call(\s+.*)', l), m):
  print(re.sub('call\s','', l))
 elif testre(re.match('\s*while\s+(.*)\)[;\s](.*)', l), m):
  print "while [ " +  m[0].groups()[0] + ") -ne 0 ] ;do " +  (m[0].groups()[1] or "true")+";done"
 else :
  sys.stdout.write(l)
  
 l = f.readline()
