function i2c_delay
#msleep $1
for letl i 0;{$i<10};letl i {$i+1}
end
ret
function i2c_gpio_start
set_gpio_out $gpio_d 1
set_gpio_out $gpio_c 1
set_gpio_out $gpio_d 0
i2c_delay 1
set_gpio_out $gpio_c 0
ret

function i2c_gpio_send
let d $1
for letl i 0;{$i<8};letl i {$i+1}
set_gpio_out $gpio_c 0
set_gpio_out $gpio_d {($d>>(7-$i))&1}
set_gpio_out $gpio_c 1
end
set_gpio_out $gpio_c 0
#set_gpio_out $gpio_d 1
ret

function i2c_gpio_rec
letl d $(get_gpio_in $gpio_d)
let v 0
for letl i 0;{$i<8};letl i {$i+1}
set_gpio_out $gpio_c 1
set_gpio_out $gpio_c 1
letl d $(get_gpio_in $gpio_d)
letl v {($v<<1)|$d}
set_gpio_out $gpio_c 0
set_gpio_out $gpio_c 0
end
echo $v
ret


function i2c_gpio_stop
set_gpio_out $gpio_c 1
set_gpio_out $gpio_d 0
set_gpio_out $gpio_c 1
set_gpio_out $gpio_d 1
ret

function i2c_gpio_rack
letl d $(get_gpio_in $gpio_d)
set_gpio_out $gpio_c 1
i2c_delay 1
letl d $(get_gpio_in $gpio_d)
set_gpio_out $gpio_c 0
echo $d
ret

function i2c_gpio_wack
set_gpio_out $gpio_d $1
set_gpio_out $gpio_c 1
set_gpio_out $gpio_c 0
ret

function i2c_gpio_read
letl addr reg ${1:0} ${2:0}
i2c_gpio_start
i2c_gpio_send $addr
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
i2c_gpio_send $reg
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
i2c_gpio_start
i2c_gpio_send {$addr|1}
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
i2c_gpio_rec
i2c_gpio_wack 1
2:
i2c_gpio_stop;ret
1:
echo_2 no ack
goto 2:b
ret

function i2c_gpio_write
letl addr reg dat ${1:0} ${2:0} ${3:0}
i2c_gpio_start
i2c_gpio_send $addr
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
i2c_gpio_send $reg
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
i2c_gpio_send $dat
letl ack $(i2c_gpio_rack)
if $ack goto 1:f
2:
i2c_gpio_stop;ret
1:
echo_2 no ack
goto 2:b
ret


function i2c_via_read
#i2c_init
letl device reg cnt ctlcmd ${1:0} ${2:0} ${3:1} ${4:8}
for letl i 0;{$i<$cnt};letl i {$i+1}
m1 $iaddr {$device|1}
m1 $icmd {$reg+$i} 
m1 $ictl $ctlcmd
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
m1 $ictl {$(d1q $ictl 1)|0x40}
while {$(d1q $ists 1)&1}
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
echo_n $(d1q $idat 1) " "
end
echo

ret

function i2c_via_read_block
#i2c_init
letl device reg cnt ${1:0} ${2:0} ${3:1}
m1 $iaddr {$device|1}
m1 $icmd {$reg} 
m1 $idat $cnt
m1 $ictl 0x14
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
m1 $ictl {$(d1q $ictl 1)|0x40}
while {$(d1q $ists 1)&1}
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
for letl i 0;{$i<$cnt};letl i {$i+1}
echo_n $(d1q $idat2 1) " "
end
echo

ret

function i2c_via_read_byte
letl device data ${1:0} ${2:0}
m1 $iaddr {$device|1}
m1 $ictl 0x4
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
m1 $ictl {$(d1q $ictl 1)|0x40}
while {$(d1q $ists 1)&1}
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
d1q $idat 1
echo

ret


function i2c_via_write_byte
#i2c_init
letl device data ${1:0} ${2:0}
m1 $iaddr {$device|0}
m1 $idat $data
m1 $ictl 0x4
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
m1 $ictl {$(d1q $ictl 1)|0x40}
while {$(d1q $ists 1)&1}
letl c $(d1q $ists 1)
if {$c&0x1f} m1 $ists $c
echo

ret




function _i2c_ls2k_stop
letl cr dr $(expr $i2creg+0x4) $(expr $i2creg+0x3)
 m1 $cr 0x40;
 while $(expr $(d1q  $cr 1)&0x40); 
ret

function _i2c_ls2k_read
letl cr dr adr count $(expr $i2creg+0x4) $(expr $i2creg+0x3) "$1" "${2:1}"
 m1 $dr $(expr $adr|0x1)
 m1 $cr 0x90;
 while $(expr $(d1q  $cr 1)&0x2); 
do while $(expr $count>0)
 m1 $cr {($count==1)?0x28:0x20};
 while $(expr $(d1q  $cr 1)&0x2); 
 echo_n $(d1q $dr 1) " "
 letl count $(expr $count-1)
end

ret

let i2c_noack 0
function _i2c_ls2k_write
letl cr dr adr $(expr $i2creg+0x4) $(expr $i2creg+0x3) ${1:0}
 let i2c_noack 0
 m1 $dr $adr;
 m1 $cr 0x90; 
 while $(expr $(d1q  $cr 1)&0x2); 
 do if $(expr $(d1q  $cr 1)&0x80)
  let i2c_noack 1;echo_2 no ack;ret
 end
 shift
 for let reg in $*
 m1 $dr $reg;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 
 do if $(expr $(d1q  $cr 1)&0x80)
  let i2c_noack 1;echo_2 no ack;ret
 end
 end
ret

function i2c_ls2k_write
_i2c_ls2k_write $*
_i2c_ls2k_stop
ret

function i2c_ls2k_read
letl cr dr adr reg count $(expr $i2creg+0x4) $(expr $i2creg+0x3) "$1" "$2" $(expr ($#>3)*($3-1)+1)
do while $(expr $count>0)
_i2c_ls2k_write $adr $reg
_i2c_ls2k_read $adr
_i2c_ls2k_stop
 letl reg count $(expr $reg+1) $(expr $count-1)
end
echo
ret

function i2c_ls2k_scan
local r
for letl i 0;{$i<0x100};letl i {$i+2}
letl v $(i2c_ls2k_read $i 0 1)
if {!$i2c_noack} letl r "$r $i"
end
echo $r
ret

function pci8619_i2c_read
letl adr reg  port {${3:0x38}<<1} ${1:0x78} ${2:4}
i2c_ls2k_write $adr 0x4 {$port>>1} {(($port&1)<<7)|0x3c|(($reg>>10)&3)} {$reg>>2}
_i2c_ls2k_read $adr 4
echo
_i2c_ls2k_stop
ret

function i2c_ls2k_read2a
letl cr dr adr reg count $(expr $i2creg+0x4) $(expr $i2creg+0x3) "$1" "$2" $(expr ($#>3)*($3-1)+1)
do while $(expr $count>0)
 m1 $dr $adr;
 m1 $cr 0x90; 
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr {$reg>>8};
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $reg;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $(expr $adr|0x1)

 m1 $cr 0x90;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $cr 0x28;
 while $(expr $(d1q  $cr 1)&0x2); 
 
 echo_n $(d1q $dr 1) " "
 
 m1 $cr 0x40;
 while $(expr $(d1q  $cr 1)&0x40); 
 letl reg count $(expr $reg+1) $(expr $count-1)
end
echo

ret

function i2c_ls2k_write2a
letl cr dr adr reg val $(expr $i2creg+0x4) $(expr $i2creg+0x3) ${1:0} ${2:0} ${3:0}
 m1 $dr $adr;
 m1 $cr 0x90; 
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr {$reg>>8};
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $reg;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 


 m1 $dr $val;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 
 m1 $cr 0x40;
 while $(expr $(d1q  $cr 1)&0x40); 

ret

function i2c_ls2k_read2
letl cr dr adr reg count $(expr $i2creg+0x4) $(expr $i2creg+0x3) "$1" "$2" $(expr ($#>3)*($3-1)+1)
do while $(expr $count>0)
 m1 $dr $adr;
 m1 $cr 0x90; 
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $reg;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $(expr $adr|0x1)

 m1 $cr 0x90;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $cr 0x20;
 while $(expr $(d1q  $cr 1)&0x2); 
 
 letl h $(d1q $dr 1)

 m1 $cr 0x28;
 while $(expr $(d1q  $cr 1)&0x2); 
 
 letl l $(d1q $dr 1)

 expr_n %"%04x " ($h<<8)|$l
 
 m1 $cr 0x40;
 while $(expr $(d1q  $cr 1)&0x40); 
 letl reg count $(expr $reg+1) $(expr $count-1)
end
echo

ret

function i2c_ls2k_write2
letl cr dr adr reg val $(expr $i2creg+0x4) $(expr $i2creg+0x3) ${1:0} ${2:0} ${3:0}
 m1 $dr $adr;
 m1 $cr 0x90; 
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr $reg;
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr {$val>>8};
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 m1 $dr {$val&0xff};
 m1 $cr 0x10;
 while $(expr $(d1q  $cr 1)&0x2); 

 
 m1 $cr 0x40;
 while $(expr $(d1q  $cr 1)&0x40); 

ret

