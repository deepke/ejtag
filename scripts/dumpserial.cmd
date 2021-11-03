function dumpserial
mems
watch ${1:0xffffffffbfe40000}
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl c $(set {($(d4q $(set pc) 1)>>16)&0x1f});
if {$c!=0x1b} expr_n  %%c $c
m4 0xFF302000 0
cont
end
ret

function dumpserial.hb
letl saddr ${1:0xffffffffbfe001e0}
mems
watch $saddr
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl c $(set {($(d4q $(set pc) 1)>>16)&0x1f});
if {$c!=0x1b} expr_n  %%c $c
#m4 0xffffffffFf302000 0
unwatch $saddr
letl npc $(nextpc)
hb $npc
cont
while {($(jtagregs d8q 10 1)&8)==0};
unhb $npc
watch $saddr
cont
end
ret

function watchprint
echo_off
mems
watch ${1:0xffffffffbfe40000} ${2:0}
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl ins $(d4q $(set pc) 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
expr %"%llx: m4 0x%x 0x%x" $pc $a $v
m4 0xFF302000 0
cont
end
ret

function awatchprint
echo_off
mems
awatch ${1:0xffffffffbfe40000} ${2:0}
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};
letl pc $(set pc)
if {$(cp0s 0 d8 23 1)&0x80000000} letl pc {$pc+4}
letl ins $(d4q $pc 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
do if {$ins&0x20000000}
letl v $(set $rt)
expr %"m4 0x%x 0x%x" $a $v
else
letl v $(d4q $a 1)
expr %"d4q 0x%x 1 ;# 0x%x" $a $v
end
m4 0xFF302000 0
cont
end
ret


function mywatchset
echo_off
letl saddr ${1:0x900000000ff00068}
letl val ${2:0}
letl mypc ${3:1}
mems
watch $saddr
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl pc $(set pc)
letl ins $(d4q $pc 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
do if {$#==3||$pc==$mypc}
set $rt $val
expr %"%s:m8 0x%llx 0x%016llx;#0x%016llx" '$(symbol show $pc)' $a $v $val
else
expr %"%s:m8 0x%llx 0x%016llx" '$(symbol show $pc)' $a $v
end
unwatch $a
letl npc $(nextpc)
hb $npc
cont
while {($(jtagregs d8q 10 1)&8)==0};
unhb $npc
watch $a
cont
end
ret

function mywatch
echo_off
mems
if {$#<2} ret

for letl i in $*
watch $i
end
cont

do while 1;
 do while 1;
  letl v $(jtagregs d8q 10 1)
   do if {($v&0x4000c000)!=0x4000c000} 
    for letl i in $*
     watch $i
    end
    cont
   elsif  {($v&8)!=0}
     loop_break 2
   end
  end

letl pc $(set pc)
letl ins $(d4q $pc 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
expr %"%s:m8 0x%llx 0x%016llx" '$(symbol show $pc)' $a $v
unwatch $a
letl npc $(nextpc)
hb $npc
cont
while {($(jtagregs d8q 10 1)&8)==0};
unhb $npc
watch $a
cont
end
ret

function mywait
do while 1
cont
dwait
end
ret



function watchgpu
echo_off
mems
watch ${1:0xffffffffbfe00180}
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl ins $(d4q $(set pc) 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
expr %"m4 0x%x 0x%x" $a $v
loop_break
end
m8 0x900000003ff00018 ${2:0x100000000}
m8 0x900000003ff00058 ${3:0xffffffffffc00000}
m8 0x900000003ff00098 ${4:0x0f0000f0}
unwatch
si.h
m4 0xffffffffbfe00180 0xf7fff51f
m8 0x90000efdfb0000f8 0xc0000048
m8 0x90000efdfb0000fc 0x0048ffff
cont
ret

function rwatchpcicfg
echo_off
mems
letl cfgaddr 0xffffffffbb020014
rwatch ${1:$cfgaddr}
cont

do while 1;
while {($(jtagregs d8q 10 1)&8)==0};

letl ins $(d4q $(set pc) 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
#expr %"m4 0x%x 0x%x" $a $v
unwatch
si.h
set $rt 0xff000000
rwatch ${1:$cfgaddr}
cont
end
ret

function watchddrparam
echo_off
setconfig log.level 0
mems

do while 1;
watch 0x900000000ff00000 0xfff
go
while {($(jtagregs d8q 10 1)&8)==0};
unwatch

letl ins $(d4q $(set pc) 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
letl v $(set $rt)
expr %"m8 0x%016llx 0x%016llx" $a $v
si.h
mems
end
setconfig log.level 1
ret


function inputserial
setconfig log.level 0
mems
letl str "$1"
letl creg dreg ${2:0xbfe48005} ${3:0xbfe48000}
rwatch $creg
rwatch $dreg

letl len $(expr1 length  "$str")
letl pos 1

do while {$pos<=$len};
cont
while {($(jtagregs d8q 10 1)&8)==0};

letl ins $(d4q $(set pc) 1)
letl rt {($ins>>16)&0x1f}
letl base {($ins>>21)&0x1f}
letl offs {$ins&0xffff}
letl offs {($offs&0x8000)?((~0xffff)|$offs):$offs}
letl a {$(set $base)+$offs}
si.h
letl v $(set $rt)
do if {$a==$creg}
set $rt {$v|0x1}
else
letl v $(expr1 ord ( substr "$str" $pos 1 ))
set $rt $v
letl pos {$pos+1}
end
end
unwatch
cont

setconfig log.level 1
ret

function waitnmi

do while 1
 stop

 if {($(jtagregs d8q 10 1)&0x40008)!=0x40008} loop_continue
 if {($(cp0s 0 d8q 12 1)&(1<<20))==0} loop_continue
 set
 cpus 0 d8 30 1
 loop_break
end

ret


let kargs 'g console=ttyS0,115200 log_buf_len=10M initcall_debug=1 loglevel=20 nousb'
let kernel /tmp/vmlinuz
let rd /tmp/rootfs.cpio.gz

function myput
#myput serialaddr #use let to set kernel, rd, kargs to boot kernel
letl serial ${1:0xffffffffbfe001e0}
stop
put64 $kernel 0xffffffff84000000
inputserial "load /dev/ram@0x84000000\n" {$serial+5} $serial
msleep 3000
put64 $rd 0xffffffff86000000
inputserial "initrd /dev/ram@0x86000000,$filesize\n" {$serial+5} $serial
msleep 3000
go
inputserial "$kargs\n"  {$serial+5} $serial
ret

function waitserial
letl str ${1:PMON>}
letl serial ${2:0xffffffffbfe001e0}
letl len $(expr1 length  "$str")
letl pos 1

do while {$pos<=$len};
letl v $(expr1 ord ( substr "$str" $pos 1 ))
watch $serial 0 1 $v
cont
while {($(jtagregs d8q 10 1)&8)==0};
unwatch
si.h
letl pos {$pos+1}
 do while {$pos<=$len};
 letl v $(expr1 ord ( substr "$str" $pos 1 ))
 watch $serial
 cont
 while {($(jtagregs d8q 10 1)&8)==0};
 letl ins $(d4q $(set pc) 1)
 letl rt {($ins>>16)&0x1f}
 letl d $(set $rt)
   do if {$d==$v}
   letl pos {$pos+1}
   else
   letl pos 1
   loop_break 2
   end
 si.h
 end
end
ret
