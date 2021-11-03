letl phy 16
letl base 0xffffffffbfe10000

function read_phy
@letl show $(@setconfig sys.showcmd)
@echo_off
letl reg ${1:0}
letl cnt ${2:1}
do while $cnt
letl data {($phy<<11)|($reg<<6)|1|0x10}
m4 {$base+0x10} $data
while {$(d4q {$base+0x10})&1};
expr_n %"0x%04x " $(d4q {$base+0x14} 1)
letl reg {$reg+1}
letl cnt {$cnt-1}
end
echo
setconfig sys.showcmd $show
@ret


function write_phy
@letl show $(@setconfig sys.showcmd)
@echo_off
letl reg ${1:0}
letl data ${2:0}
m4 {$base+0x14} $data
letl data {($phy<<11)|($reg<<6)|2|1|0x10}
m4 {$base+0x10} $data
while {$(d4q {$base+0x10})&1};
setconfig sys.showcmd $show
@ret

function write_phy_reg_val
let phy ${1:0} 
write_phy ${2:0} ${3:0}
ret

function read_phy_reg_cnt
let phy ${1:0} 
read_phy ${2:0} ${3:1}
ret



function print_speed
letl stat $1
letl lpa2 $(read_phy 0xa)
letl bmcr2 $(read_phy 0x9)
letl avert $(read_phy 0x4)
letl lpa $(read_phy 0x5)
letl nego {$lpa&$avert}
letl bmsr $(read_phy 1)

do if {$bmsr&4}
letl link "link up"
else
letl link "link down"
end


do if {$bmcr2&0x300&($lpa2>>2)}
letl speed "speed 1000M"
elsif {$nego&0x0180}
letl speed "speed 100M"
else 
letl speed "speed 10M"
end

do if {($lpa2&0x0800)|($nego&0x140)}
letl duplex "duplex full"
else
letl duplex "duplex half"
end

echo $link $speed $duplex
ret


function print_speed1
letl s $(d4q {$base+0xd8} 1)
do if {$s&8}
letl link "link up"
else
letl link "link down"
end

let m {($s>>1)&3}

do if {$m==2}
letl speed "speed 1000M"
elsif {$m==1}
letl speed "speed 100M"
else 
letl speed "speed 10M"
end

do if {$s&1}
letl duplex "duplex full"
else
letl duplex "duplex half"
end

echo $link $speed $duplex
ret

function find_phy
letl phy0 -1
letl oldphy ${phy:0}
for letl i 0;{$i<32};letl i {$i+1}
let phy $i
letl v $(read_phy 2)
 do if {$v!=0&&$v!=0xffff} 
  echo find phy $phy
  print_speed
  letl phy0 $phy
 end
end
do if {$phy0!=-1}
let phy $phy0
echo phy is $phy
else
let phy $oldphy
echo can not find phy
end
ret


function switch_mv88e6070_phy_read 
@echo_off
letl addr reg cnt ${1:0x10} ${2:0} ${3:1}
let phy 0x17
do while $cnt
write_phy 0x18  {0xf800|($addr<<5)|$reg}
while {$(read_phy 0x18 1)&0x8000}
echo_n $(read_phy 0x19 1) ' '
letl reg cnt {$reg+1} {$cnt-1}
end
echo
ret

function switch_mv88e6070_phy_write
@echo_off
letl addr reg ${1:0x10} ${2:0}
let phy 0x17
write_phy 0x19 $reg
write_phy 0x18  {0xf400|($addr<<5)|$reg}
while {$(read_phy 0x18 1)&0x8000}
ret

function vbus2phys
expr ($1>0x90000000)?$1:($1&0x0fffffff)
ret

function gmacdesc
letl bar0 $base
letl tb $(d4q $(($bar0+0x1010)) 1)
letl rb $(d4q $(($bar0+0x100c)) 1)
letl tbl $(d8q $(($bar0+0x1098)) 1)
letl rbl $(d8q $(($bar0+0x1090)) 1)

letl curtb $(d4q $(($bar0+0x1048)) 1)
letl currb $(d4q $(($bar0+0x104c)) 1)

letl curtbl $(($(d4q $(($bar0+0x10a0)) 1)<<4))
letl currbl $(($(d4q $(($bar0+0x10a8)) 1)<<4))

letl newf $(d4q $(($bar0+0x00001080)) 1)

do if [ $(($newf&0x100)) -ne 0 ]
expr %"tb:0x%llx  rb:0x%llx curtb:0x%llx currb:0x%llx\n" $tbl $rbl $curtbl $currbl
letl tbl $(vbus2phys $tbl)
letl rbl $(vbus2phys $rbl)
letl curtbl $(vbus2phys $curtbl)
letl currbl $(vbus2phys $currbl)
echo tb
d4 {0x9800000000000000+$tbl} {8*16/4}
echo curtb: $curtbl
d4 {0x9800000000000000+(($tbl<($curtb-4*32))?($curtbl-4*32):$tbl)} {8*32/4}
echo rb
d4 {0x9800000000000000+$rbl} {8*16/4}
echo currb: $currbl
d4 {0x9800000000000000+(($rbl<($currbl-4*32))?($currbl-4*32):$rb)} {8*32/4}
else
echo tb:$tb rb:$rb curtb:$curtb currb:$currb
letl tb $(vbus2phys $tb)
letl rb $(vbus2phys $rb)
letl curtb $(vbus2phys $curtb)
letl currb $(vbus2phys $currb)
echo tb
d4 {0x9800000000000000+$tb} {8*32/4}
echo curtb: $curtb
d4 {0x9800000000000000+(($tb<($curtb-4*32))?($curtb-4*32):$tb)} {8*32/4}
echo rb
d4 {0x9800000000000000+$rb} {8*16/4}
echo currb: $currb
d4 {0x9800000000000000+(($rb<($currb-4*32))?($currb-4*32):$rb)} {8*32/4}
end
ret

