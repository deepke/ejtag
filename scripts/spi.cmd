let spibase ${spibase:0xffffffffbfff0220}
let spi_cs 0
let spi_speed 4

function spi_set_cs
do if $1
m1 {$spibase+0x5} 0xff
else
m1 {$spibase+0x5} {0xff^(0x10<<$spi_cs)}
end
ret

function spi_send_data
spi_qsend_data:f
m1 {$spibase+0x2} $1
while {$(d1q {$spibase+0x1} 1)&1};
letl v $(d1q {$spibase+0x2} 1)
if $(test $0 == spi_send_data) echo $v
ret


function spi_readid
call spi_init $spi_speed

spi_set_cs 0
let v $(spi_send_data 0x9f)
letl mf $(spi_send_data 0xff)
letl type $(spi_send_data 0xff)
letl cap $(spi_send_data 0xff)
spi_set_cs 1

echo $mf $type $cap

ret


function spi_read_area
let addr cnt ${1:0} ${2:16}
call spi_init $spi_speed

spi_set_cs 0
spi_qsend_data 3
spi_qsend_data {$addr>>16}
spi_qsend_data {$addr>>8}
spi_qsend_data $addr
for letl i 0;{$i<$cnt};letl i {$i+1}
letl v $(spi_send_data 0xff)
if {($i&0xf)==0} expr_n "%\n%04x: " {$addr+$i}
echo_n "$v  "
end
spi_set_cs 1
echo
ret

function spi_wait_sr
spi_set_cs 0
spi_qsend_data 5
while {$(spi_send_data 0xff)&1}
spi_set_cs 1
ret

function spi_set_wren
spi_wait_sr
spi_set_cs 0
spi_qsend_data 6
spi_set_cs 1
spi_set_cs 0
spi_qsend_data 5
while {!($(spi_send_data 0xff)&2)}
spi_set_cs 1
ret

function spi_write_sr
let sr ${1:0}
spi_set_wren
spi_wait_sr
spi_set_cs 0
spi_qsend_data 1
spi_qsend_data $sr
spi_set_cs 1
ret

function spi_read_sr
spi_set_cs 0
spi_qsend_data 5
spi_send_data 0
spi_set_cs 1
ret

function spi_write_area
let addr ${1:0}
call spi_init $spi_speed
spi_write_sr 0
spi_set_wren

spi_set_cs 0
spi_qsend_data 2
spi_qsend_data {$addr>>16}
spi_qsend_data {$addr>>8}
spi_qsend_data $addr
shift
for letl i in $*
spi_qsend_data $i
end
spi_set_cs 1
spi_wait_sr
ret

function spi_init
letl d ${1:4}
m1 {$spibase+0x1} 0xc0
m1 {$spibase+0x4} {$d<<4}
m1 {$spibase+0x3} {(0x5&~3)|(($d>>2)&3)}
m1 {$spibase+0x6} 0x1
m1 {$spibase+0x0} {(0x51&~3)|($d&3)}
m4 0xffffffffff200100 $spibase
setconfig spi.inited 1
ret

function spi_mytest
call spi_init $spi_speed
spi_set_cs 0
for letl i in  0xaa 0x31 0x01 0x00 0x01 0x31
spi_send_data $i
end
msleep 1
spi_send_data 0xff
spi_set_cs 1
ret

function spi_memen
letl en ${1:1}
letl o $(d1q {$spibase+0x4} 1)
do if $en
m1  {$spibase+0x4} {$o|1}
else
m1  {$spibase+0x4} {$o&~1}
end
ret

function spi_sst_wen
letl en {${1:1}?0:0xff}
call spi_init $spi_speed
letl mf type cap $(spi_readid)
do if {($mf==0xbf)&&($type==0x26)}
spi_set_cs 0;
spi_qsend_data 0x42;
for letl i 0;{$i<18};letl i {$i+1}
spi_qsend_data $en;
end
spi_set_cs 1
end
ret

function spi_erase_all
call spi_init $spi_speed
spi_write_sr 0
spi_set_wren
spi_set_cs 0;
spi_qsend_data 0xc7;
spi_set_cs 1;
do while 1
let sr $(spi_read_sr)
echo_n '\r$sr'
if {($sr&3)==0} loop_break
end
ret

function spi_erase_area
let addr ${1:0}
call spi_init $spi_speed
spi_set_wren
spi_wait_sr

spi_set_cs 0
spi_qsend_data 0xd8
spi_qsend_data {$addr>>16}
spi_qsend_data {$addr>>8}
spi_qsend_data $addr
spi_set_cs 1
spi_wait_sr
ret

function spi_gd25_diesel
call spi_init $spi_speed
spi_set_cs 0
spi_qsend_data 0xc2
spi_qsend_data ${1:0}
spi_set_cs 1

ret

function spi_cmd
spi_set_cs 0
for letl i in $*
 do if $(test ${i#0#1} == -)
  spi_qsend_data ${i#1}
 else
  spi_send_data $i
 end
end
spi_set_cs 1
ret

function spi_fifoclear
 do while {($(d1q {$spibase+0x1} 1)&1)==0}
  let t $(d1q {$spibase+0x2} 1)
 end
ret
