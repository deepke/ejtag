function gdb_module_setup
ret

function gdb
gdb_remote:f
gdbmod_remote:f
gdbmod:f
gdbmod0_remote:f
gdbmod0:f
eclipse:f
eclipse_remote:f
eclipsemod:f
eclipsemod_remote:f
ddd:f
ddd_remote:f
dddemod:f
dddmod_remote:f

letl m $(setconfig gdbserver.cpubitmap)
letl n $(setconfig core.cpuno)
while {((1<<$n)&$m)==0} letl n {$n+1}
setconfig core.cpuno $n

do if {($(expr1 match $0  .*remote.*)+0)||$(setconfig gdbserver.sim)}

letl ibc 1
letl dbc 1

else
letl indebug {$(jtagregs d8q 10 1)&8}
letl ibc $(expr ($(d4q 0xffffffffff301000 1)>>24)&0xf)
letl dbc $(expr ($(d4q 0xffffffffff302000 1)>>24)&0xf)
if {!$indebug} cont
end

do if {$(expr1 match $0 .*remote.*)+0}
letl addrport ${1:127.0.0.1:50010}
letl pidx $(expr1 index $addrport :)
letl ip $(expr1 substr $addrport 1 {$pidx-1})
letl port $(expr1 substr $addrport {$pidx+1} 10)
shift
else
letl port $(gdbserver 0)
letl ip 127.0.0.1
end

letl pid $(fork)
do if $pid
do if {!($(expr1 match $0 .*remote.*)+0)}
gdbserver $port 1
end
sigintoff
wait
siginton
else
> gdb.cmd echo_n
 do if $(expr $(setconfig core.cpuwidth)==32)
>> gdb.cmd echo set architecture mips:isa32r2
 else
>> gdb.cmd echo set architecture mips:isa64r2
 end
 do if $(expr $(setconfig core.abisize)==32)
>> gdb.cmd echo set mips abi o32
 else
>> gdb.cmd echo set mips abi n64
 end
>> gdb.cmd echo set remotetimeout 20
>> gdb.cmd echo set remote hardware-breakpoint-limit $ibc
>> gdb.cmd echo set remote hardware-watchpoint-limit $dbc
>> gdb.cmd echo define mysi
>> gdb.cmd echo monitor si 0
>> gdb.cmd echo c
>> gdb.cmd echo end
>> gdb.cmd echo define myedit
>> gdb.cmd echo set listsize 1
>> gdb.cmd echo edit
>> gdb.cmd echo set listsize 10
>> gdb.cmd echo end
>> gdb.cmd echo set height 0
>> gdb.cmd echo set logging on ${TIME+log/gdb-%Y%m%d-%H%M%S.log}
#>> gdb.cmd echo set debug remote -1
do if {$(expr1 match $0 .*mod.*)+0}

do if {$(expr1 match $0 .*mod0.*)+0}
 do if $(expr $(setconfig core.abisize)==32)
! perl scripts/gdb.proxy.32 $@ $ip:$port
 else
! perl scripts/gdb.proxy.64 $@ $ip:$port
 end
>> gdb.cmd echo source scripts/gdb.func
else
 do if $(expr $(setconfig core.abisize)==32)
! python scripts/gdb.proxy.32.py $@ $ip:$port
 else
! python scripts/gdb.proxy.64.py $@ $ip:$port
 end
>> gdb.cmd echo source scripts/linux.py
end

> .gdbinit cat gdb.cmd
>> gdb.cmd echo target remote 127.0.0.1:9000
gdb_module_setup
letl ip 127.0.0.1
letl port 9000
else
> .gdbinit cat gdb.cmd
>> gdb.cmd echo target remote $ip:$port
end

do if {$(expr1 match $0 .*eclipse.*)+0}
letl newworkspace ${WORKSPACE:workspace1}
do if $(test -z "$WINDIR")
! cp -a workspace/. $newworkspace
else
#! xcopy /y/s/e/q/k/h/r workspace $newworkspace\\
> xcpy.bat echo xcopy /y/s/e/q/k/h/r workspace $newworkspace\\
! xcpy.bat
end
> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch cat -2 workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch echo  '<stringAttribute key="org.eclipse.cdt.dsf.gdb.DEBUG_NAME" value="'${GDB:mipsel-gdb} ${1}'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch echo  '<stringAttribute key="org.eclipse.cdt.dsf.gdb.PORT" value="'$port'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch echo   '<stringAttribute key="org.eclipse.cdt.dsf.gdb.HOST" value="'$ip'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch echo  '<stringAttribute key="org.eclipse.cdt.dsf.gdb.GDB_INIT" value="'.gdbinit'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch cat +7  workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/attach.launch

> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch cat -2 workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch echo '<stringAttribute key="org.eclipse.cdt.dsf.gdb.DEBUG_NAME" value="'${GDB:mipsel-gdb}'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch echo '<stringAttribute key="org.eclipse.cdt.launch.PROGRAM_NAME" value="'${1}'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch echo '<stringAttribute key="org.eclipse.cdt.dsf.gdb.HOST" value="'$ip'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch echo '<stringAttribute key="org.eclipse.cdt.dsf.gdb.PORT" value="'$port'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch echo '<stringAttribute key="org.eclipse.cdt.dsf.gdb.GDB_INIT" value="'.gdbinit'"/>'
>> $newworkspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch cat +8 workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/debug.launch
! eclipse -data $newworkspace
elsif {$(expr1 match $0 .*ddd.*)+0}
! ddd --debugger ./mipsel-gdb -x gdb.cmd $@
else
! ${GDB:./mipsel-gdb} -x gdb.cmd $@
end
exit 0
end
ret

function fls
for letl num i "$1" 31;$(expr $i>=0);letl i $(expr $i-1)
 if $(expr $num&(1<<$i)) loop_break
end
echo $i
ret

function cache_config
letl prid config2 slines ssets sways $(cp0s 0 d4q 15 1) $(cp0s 2 d4q 16 1) 0 0 0

do if $(expr $prid==0x6305||$prid==0x00146308||$prid==0x146101||$prid==146309) 
letl slines ssets sways $(expr %"0x%x 0x%x 0x%x" 2<<(($config2>>4)&15) 64<<(($config2>>8)&15) 1+(($config2)&15)) 
letl cpucount $(setconfig core.cpucount)
letl ssize $(expr $ssets*$slines*$sways*$cpucount)
letl swaybit iwaybit dwaybit 0 0 0
setconfig scache.size $ssize
setconfig scache.ways $sways
setconfig scache.waybit $swaybit
end

letl config1 $(cp0s 1 d4q 16 1)
letl isets ilines iways $(expr  %"0x%x 0x%x 0x%x" 64<<(($config1>>22)&7) 2<<(($config1>>19)&7)  1+(($config1>>16)&7)) 
letl isize $(expr $isets*$ilines*$iways)
letl dsets dlines dways $(expr  %"0x%x 0x%x 0x%x" 64<<(($config1>>13)&7) 2<<(($config1>>10)&7) 1+(($config1>>7)&7)) 
letl dsize $(expr $dsets*$dlines*$dways)

if $(expr $prid!=0x6305) letl dwaybit $(fls {$dsets*$dlines})

setconfig icache.size $isize
setconfig icache.ways $iways
setconfig icache.waybit $iwaybit
setconfig dcache.size $dsize
setconfig dcache.ways $dways
setconfig dcache.waybit $dwaybit

ret


function cache_init
setconfig core.nocache 0
cp0s
m4 29 0
m4 28 0
mems

cache 9 0xffffffff9fc00000 0x4000
cache 0 0xffffffff9fc00000 0x4000
cache 1 0xffffffff9fc00000 0x4000

cp0s
m4 16 3
mems
ret



function check_ejtag
ejtag_check:f
letl clkdiv ${1:1}
jtag_clk $clkdiv
msleep 1000
letl ok 0
stop

letl cr $(jtagregs d8q 10 1)
do while {(($cr&8)==0)||!$cr}
stop
letl cr $(jtagregs d8q 10 1)
end

let l $(jtagregs d4q 1 1)

do while {$l!=0x5a5a5a5a&&$l!=0x20010819}
echo ejtag link failed
let l $(jtagregs d4q 1 1)
end
stop
again:

for letl i 0;{$i<10000}; letl i {$i+1};
let d $(jtagregs d4q 1 1)
if {$d!=$l} loop_break
end

do if {$d==$l}
echo check ok
letl ok {$ok+1}
if {$ok<5} goto again
else
echo check failed, read $l as $d on $i, cldiv is $clkdiv
letl ok 0
letl clkdiv {$clkdiv<<1}
jtag_clk $clkdiv
msleep 1000
goto again
end
echo clkdiv is $clkdiv

ret


function gdbserver

letl m $(setconfig gdbserver.cpubitmap)
letl n $(setconfig core.cpuno)
while {((1<<$n)&$m)==0} letl n {$n+1}
setconfig core.cpuno $n

do if $(setconfig gdbserver.sim)
letl indebug 1
else
letl indebug {$(jtagregs d8q 10 1)&8}
end

letl ibc $(expr ($(d4q 0xffffffffff301000 1)>>24)&0xf)
letl dbc $(expr ($(d4q 0xffffffffff302000 1)>>24)&0xf)
if {!$indebug} cont

letl port $(gdbserver 0)
> gdb.cmd echo_n
 do if $(expr $(setconfig core.cpuwidth)==32)
>> gdb.cmd echo set architecture mips:isa32r2
 else
>> gdb.cmd echo set architecture mips:isa64r2
 end
 do if $(expr $(setconfig core.abisize)==32)
>> gdb.cmd echo set mips abi o32
 else
>> gdb.cmd echo set mips abi n64
 end
>> gdb.cmd echo set remotetimeout 20
>> gdb.cmd echo set remote hardware-breakpoint-limit $ibc
>> gdb.cmd echo set remote hardware-watchpoint-limit $dbc
>> gdb.cmd echo define mysi
>> gdb.cmd echo monitor si 0
>> gdb.cmd echo c
>> gdb.cmd echo end
>> gdb.cmd echo define myedit
>> gdb.cmd echo set listsize 1
>> gdb.cmd echo edit
>> gdb.cmd echo set listsize 10
>> gdb.cmd echo end
#>> gdb.cmd echo set debug remote -1
> .gdbinit cat gdb.cmd
>> gdb.cmd echo target remote 127.0.0.1:$port
gdbserver $port 1
ret

function localmem
newfunc f_d "devmem \{$$2&0xffffffffff} \{%%d $$1*8} $$3 $$4"
newfunc f_dq "devmem \{$$2&0xffffffffff} \{%%d $$1*8}"
newcmd d1 'f_d 1'
newcmd d2 'f_d 2'
newcmd d4 'f_d 4'
newcmd d8 'f_d 8'
newcmd d1q 'f_dq 1'
newcmd d2q 'f_dq 2'
newcmd d4q 'f_dq 4'
newcmd d8q 'f_dq 8'
newcmd m1 'f_d 1'
newcmd m2 'f_d 2'
newcmd m4 'f_d 4'
newcmd m8 'f_d 8'
ret

function devmem
newfunc f_d "echo_2 devmem \{$$2&0xffffffffff} \{%%d $$1*8} $$3 $$4"
newfunc f_dq "echo_2 devmem \{$$2&0xffffffffff} \{%%d $$1*8}; echo $$RANDOM;"
newcmd d1 'f_d 1'
newcmd d2 'f_d 2'
newcmd d4 'f_d 4'
newcmd d8 'f_d 8'
newcmd d1q 'f_dq 1'
newcmd d2q 'f_dq 2'
newcmd d4q 'f_dq 4'
newcmd d8q 'f_dq 8'
newcmd m1 'f_d 1'
newcmd m2 'f_d 2'
newcmd m4 'f_d 4'
newcmd m8 'f_d 8'
ret

function dummy
newfunc f_dq "echo_2 $$1 $$2; echo $$RANDOM;"
newcmd d1 'echo_2 d1'
newcmd d2 'echo_2 d2'
newcmd d4 'echo_2 d4'
newcmd d8 'echo_2 d8'
newcmd d1q 'f_dq d1q'
newcmd d2q 'f_dq d2q'
newcmd d4q 'f_dq d4q'
newcmd d8q 'f_dq d8q'
newcmd m1 'echo_2 m1'
newcmd m2 'echo_2 m2'
newcmd m4 'echo_2 m4'
newcmd m8 'echo_2 m8'
ret

function myput64
letl f ${1:/srv/tftp/vmlinux}
letl l $(test -s $f)
letl b 0x80000
for letl o 0;{$o<$l};letl o {$o+$b}
stop
put64 $f {0xffffffff88000000+$o} $b $o
go
msleep 2000
end
ret

function jtag_clk
letl clk ${1:1}
usblooptest 0x81000070  {0x10000|$clk}
do if {$#>2}
letl phase $2
usblooptest 0x81000070  {0x20000|$phase}
end
ret

function ls1c_ejtag_init
devmem 0x1fd011c4 32 {$(devmem 0x1fd011c4)&~((0xf<<14)|(1<<21)|(1<<27))}
devmem 0x1fd011d4 32 {$(devmem 0x1fd011d4)&~((0xf<<14)|(1<<21)|(1<<27))}
devmem 0x1fd011e4 32 {$(devmem 0x1fd011e4)&~((0xf<<14)|(1<<21)|(1<<27))}
devmem 0x1fd011f4 32 {$(devmem 0x1fd011f4)&~((0xf<<14)|(1<<21)|(1<<27))}   
devmem 0x1fd01204 32 {$(devmem 0x1fd01204)&~((0xf<<14)|(1<<21)|(1<<27))}

devmem 0x1fd011c8 32 {$(devmem 0x1fd011c8)&~((1<<23))}
devmem 0x1fd011d8 32 {$(devmem 0x1fd011d8)&~((1<<23))}
devmem 0x1fd011e8 32 {$(devmem 0x1fd011e8)&~((1<<23))}
devmem 0x1fd011f8 32 {$(devmem 0x1fd011f8)&~((1<<23))}
devmem 0x1fd01208 32 {$(devmem 0x1fd01208)&~((1<<23))}

#gpio59 output 0                                                          
devmem 0x1fd010c4 32 {$(devmem 0x1fd010c4)|(1<<27)}
devmem 0x1fd010f4 32 {$(devmem 0x1fd010f4)&~(1<<27)}
devmem 0x1fd010d4 32 {$(devmem 0x1fd010d4)&~(1<<27)}

#gpio87 input                                       
devmem 0x1fd010c8 32 {$(devmem 0x1fd010c8)|(1<<23)}
devmem 0x1fd010d8 32 {$(devmem 0x1fd010d8)|(1<<23)}

devmem 0x1fd010c4 32 {$(devmem 0x1fd010c4)|(0xf<<14)|(1<<21)}
devmem 0x1fd010f4 32 {$(devmem 0x1fd010f4)&~((0xf<<14)|(1<<21))}
devmem 0x1fd010d4 32 {($(devmem 0x1fd010d4)&~((0xd<<14)|(1<<21)))|(1<<15)}
echo 0x1fd010d4=$(devmem 0x1fd010d4)

setconfig gpio.tck  0x1fd010f4.14
setconfig gpio.tms  0x1fd010f4.17
setconfig gpio.tdi  0x1fd010f4.16
setconfig gpio.tdo  0x1fd010e4.15
setconfig gpio.trst 0x1fd010f4.21
ret

function mysi
hb 0 -1
loop -1 'cont;dwait'
ret

function mySi
Hb 0 -1
loop -1 'go;Dwait'
ret

