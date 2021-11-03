letl nand_msize nand_osize nand_cap nand_esize 2048 64 0 0x2000
let ecc_msize {$nand_msize/204*188}
letl ecc_nonce 204
letl ecc_donce 188
letl ncmd 0xbfe78000
letl orderreg 0xbfd01160

function physaddr
echo {$1&0x1fffffff}
ret

function nand_init
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
m4 $csrdy {0x11<<($cs*9)}
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
m4 $nparam 0x5000
m4 $csrdy {0x11<<($cs*9)}
m4 $timing 0x412
m4 $ncmd 0x41
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
m4 $nparam 0x5000
m4 $naddr {$cs*0x10000}
m4 $ncmd 0x21
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
letl l h $(d4q $nid 2)
letl dev {$l>>24}
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
m4 $csrdy {0x11<<($cs*9)}
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
m4 $csrdy {0x11<<($cs*9)}
m4 $nopnum {($size+$nand_esize-1)/$nand_esize}
m4 $ncmd 0x0
m4 $ncmd 0x10
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
letl desc ${desc:0xffffffffa000e000}
letl addr ${1:0}
letl size ${2:$nand_msize}
letl ddr ${3:0xffffffffa0008000}

m4 $nparam {((($mode&1)*$nand_msize+($mode>>1)*$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy {0x11<<($cs*9)}
m4 $naddc {($mode==2)?$nand_msize:($addr&($nand_msize-1))}
m4 $nopnum $size
#m4 $orderreg 0x18


#       order saddr daddr length step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0 1 0
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};

m4 $ncmd {0x002|($mode<<8)}
m4 $ncmd {0x003|($mode<<8)}
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
letl desc ${desc:0xffffffffa000e000}
letl addr ${1:0}
letl size ${2:$nand_msize}
letl ddr ${3:0xffffffffa0008000}

m4 $nparam {((($mode&1)*$nand_msize+($mode>>1)*$nand_osize)<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy {0x11<<($cs*9)}
m4 $naddc {($mode==2)?$nand_msize:($addr&($nand_msize-1))}
m4 $nopnum $size
#m4 $orderreg 0x18


#       order saddr daddr length step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0 1 0x1000
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};
m4 $ncmd {0x004|($mode<<8)}
m4 $ncmd {0x005|($mode<<8)}
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret

function nand_eccread
nand_eccread0:
nand_eccread1:
nand_eccread2:
nand_eccread3:
letl naddc {$ncmd+4}
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 13 1)
letl desc ${desc:0xa000e000}
letl addr ${1:0}
letl size ${2:$ecc_msize}
letl ddr ${3:0xa0008000}

letl size {$size/$ecc_donce*$ecc_donce}

m4 $nparam {($nand_msize<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy {0x11<<($cs*9)}
m4 $naddc {$addr&($nand_msize-1)}
m4 $nopnum {$size/$ecc_donce*$ecc_nonce}
m4 $orderreg 0x18


#       order saddr daddr length step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0 1 0
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};
#m4 $ncmd 0
m4 $ncmd 0x4902
m4 $ncmd 0x4903
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret


function nand_eccwrite
nand_eccwrite0:
nand_eccwrite1:
nand_eccwrite2:
nand_eccwrite3:
letl naddc {$ncmd+4}
letl naddr {$ncmd+8}
letl nparam {$ncmd+0x18}
letl nopnum {$ncmd+0x1c}
letl csrdy {$ncmd+0x20}
letl cs 0$(expr1 substr $0 14 1)
letl desc ${desc:0xa000e000}
letl addr ${1:0}
letl size ${2:$ecc_msize}
letl ddr ${3:0xa0008000}

letl size {$size/$ecc_donce*$ecc_donce}

m4 $nparam {($nand_msize<<16)|($nand_cap<<8)}
m4 $naddr {($cs*0x10000)|($addr/$nand_msize)}
m4 $csrdy {0x11<<($cs*9)}
m4 $naddc {$addr&($nand_msize-1)}
m4 $nopnum {$size/$ecc_donce*$ecc_nonce}
m4 $orderreg 0x18


#       order saddr               daddr                  length   step_length step_times cmd
m4 $desc 0    $(physaddr $ddr) {($ncmd+0x40)&0x1fffffff} {$size/4} 0             1       0x1000
m4 $orderreg {($desc&0x1fffffff)|8}
while {$(d4q $orderreg 1)&8};
#m4 $ncmd 0
m4 $ncmd 0x5104
m4 $ncmd 0x5105
while {($(d4q $ncmd 1)&0x400)==0}
m4 $ncmd 0
ret



function nand_write_pmon
@echo_off

letl file ${1:/tmp/gzrom.bin}
letl len $(test -s $file)
letl ln {$len/$ecc_msize*$nand_msize+1}
letl ddr 0xa0200000

put $file $ddr

nand_erase 0 $ln

for letl offs 0;{$offs<$ln}; letl offs ddr {$offs+$nand_msize} {$ddr+$ecc_msize}
nand_eccwrite $offs $ecc_msize $ddr
echo $offs $ddr
end
ret

function nand_read_pmon
@echo_off
letl len ${1:0x100000}
letl ln {$len/$ecc_msize*$nand_msize+1}
letl ddr 0xa0200000
for letl offs 0;{$offs<$ln}; letl offs ddr {$offs+$nand_msize} {$ddr+$ecc_msize}
nand_eccread $offs $ecc_msize $ddr
echo $offs $ddr
end
ret


function nand_write_necc_pmon
@echo_off

letl file ${1:/tmp/gzrom.bin}
letl len $(test -s $file)
letl ln {$len/$nand_msize*$nand_msize+1}
letl ddr 0xa0200000

put $file $ddr

nand_erase 0 $ln

for letl offs 0;{$offs<$ln}; letl offs ddr {$offs+$nand_msize} {$ddr+$nand_msize}
nand_write $offs $nand_msize $ddr
echo $offs $ddr
end
ret


function nand_read_necc_pmon
@echo_off
letl len ${1:0x100000}
letl ln {$len/$nand_msize*$nand_msize+1}
letl ddr 0xa0200000
for letl offs 0;{$offs<$ln}; letl offs ddr {$offs+$nand_msize} {$ddr+$nand_msize}
nand_read $offs $nand_msize $ddr
echo $offs $ddr
end
ret

function nand_read_necc_raw_pmon
@echo_off
letl len ${1:0x100000}
letl ln {$len/$nand_msize*$nand_msize+1}
letl ddr 0xa0200000
letl tddr 0xa0100000
for letl offs 0;{$offs<$ln}; letl offs ddr {$offs+$nand_msize} {$ddr+$ecc_msize}
nand_read $offs $nand_msize $tddr
 for letl i j 0 0;{$i<2040};letl i j {$i+204} {$j+188}
  memcpy4 {$ddr+$j}  {$tddr+$i} 188
 end
echo $offs $ddr
end
ret

