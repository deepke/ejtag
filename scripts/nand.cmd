letl nand_msize nand_osize nand_cap nand_esize 8192 256 7 0x20000
letl ncmd 0xffffffffbfe06000
letl orderreg 0xffffffffbfe10c00

function physaddr
echo {($1>0xffffffff80000000&&$1<0xffffffff90000000)?($1&0x1fffffff):($1&0xffffffff)}
ret

function nand_init
m4 0xffffffffbfe10420 {$(d4q 0xffffffffbfe10420 1)|(1<<9)}
ret

function nand_reset
nand_reset1:
nand_reset2:
nand_reset3:
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl timing {$ncmd+0xc}
letl cs 0$(expr1 substr $0 11 1)
m4 $nparam {(($nand_msize+$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {$cs*0x10000}
m4 $csrdy 0x88442200
m4 $timing 0x412
m4 $nopnum 0
m4 $ncmd 0x0
m4 $ncmd 0x41
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret

function nand_readid
nand_readid0:
nand_readid1:
nand_readid2:
nand_readid3:
letl naddr {$ncmd+8}
letl naddc {$ncmd+4}
letl nparam {$ncmd+0x18}
letl csrdy {$ncmd+0x20}
letl timing {$ncmd+0xc}
letl nid {$ncmd+0x10}
letl cs 0$(expr1 substr $0 12 1)
m4 $naddr {$cs*0x10000}
m4 $naddc 0
m4 $nparam 0x6000
m4 $csrdy 0x88442200
m4 $timing 0x412
m4 $ncmd 0x41
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
m4 $nparam 0x6000
m4 $naddr {$cs*0x10000}
m4 $ncmd 0x21
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
letl l h $(d4q $nid 2)
letl dev {$h&0xff}
do if {$dev==0x64}
#let nand_msize nand_osize nand_cap nand_esize 8192 744 7 0x200000
let nand_msize nand_osize nand_cap nand_esize 8192 512 7 0x200000
elsif {$dev==0xf1}
let nand_msize nand_osize nand_cap nand_esize 2048 64 0 0x20000
elsif {$dev==0x48}
let nand_msize nand_osize nand_cap nand_esize 4096 128 4 0x80000
end

echo $l $h
ret

function nand_erase
nand_erase0:
nand_erase1:
nand_erase2:
nand_erase3:
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 11 1)
letl addr ${1:0}
letl size ${2:$nand_msize}
m4 $nparam {(($nand_msize+$nand_osize)<<16)|($nand_cap<<8)}
for letl i 0;{$i<$size};letl i addr {$i+$nand_esize} {$addr+$nand_esize}
m4 $naddr {$cs*0x10000|$addr/$nand_msize}
if {($i&0xfffffff)==0} expr %"%x" $addr
m4 $csrdy 0x88442200
m4 $nopnum 0
m4 $ncmd 0x0
m4 $ncmd 0x9
while {($(d4q $ncmd 1)&0x400)==0}
end
ret

function nand_Erase
nand_Erase0:
nand_Erase1:
nand_Erase2:
nand_Erase3:
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 11 1)
letl addr ${1:0}
letl size ${2:$nand_msize}
m4 $nparam {(($nand_msize+$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {$cs*0x10000|$addr/$nand_msize}
m4 $csrdy 0x88442200
m4 $nopnum {($size+$nand_esize-1)/$nand_esize}
m4 $ncmd 0x0
m4 $ncmd 0x11
while {($(d4q $ncmd 1)&0x400)==0}
ret

function nand_read
nand_read0:
nand_read1:
nand_read2:
nand_read3:
nand_read0m:
nand_read1m:
nand_read2m:
nand_read3m:
nand_read0o:
nand_read1o:
nand_read2o:
nand_read3o:
letl naddc {$ncmd+4}
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 10 1)
letl m mo mm 3 2 1
letl mode m$(expr1 substr $0 11 1)
letl mode ${$mode}
letl desc ${desc:0xffffffff8000e000}
letl addr ${1:0}
letl size ${2:$nand_msize}
letl ddr ${3:0xffffffff80008000}

m4 $nparam {((($mode&1)*$nand_msize+($mode>>1)*$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy 0x88442200
m4 $naddc {($mode==2)?$nand_msize:($addr&($nand_msize-1))}
m4 $nopnum $size
m4 $ncmd 0
#m4 $orderreg 0x18
m4 $ncmd {0x003|($mode<<8)}


#       order saddr daddr length step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0 1 0
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret


function nand_write
nand_write0:
nand_write1:
nand_write2:
nand_write3:
nand_write0m:
nand_write1m:
nand_write2m:
nand_write3m:
nand_write0o:
nand_write1o:
nand_write2o:
nand_write3o:
letl naddc {$ncmd+4}
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 11 1)
letl m mo mm 3 2 1
letl mode m$(expr1 substr $0 12 1)
letl mode ${$mode}
letl desc ${desc:0xffffffff8000e000}
letl addr ${1:0}
letl size ${2:$nand_msize}
letl ddr ${3:0xffffffff80008000}

m4 $nparam {((($mode&1)*$nand_msize+($mode>>1)*$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy 0x88442200
m4 $naddc {($mode==2)?$nand_msize:($addr&($nand_msize-1))}
m4 $nopnum $size
m4 $ncmd 0
#m4 $orderreg 0x18
m4 $ncmd {0x005|($mode<<8)}


#       order saddr daddr length step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0 1 0x1000
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret


