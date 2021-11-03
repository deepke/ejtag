#!/usr/bin/perl

=head1 myoprofile1
perl myoprofile1.pl vmlinux sample.dat /tmp/loadmodule.txt

first param is kernel or pmon program with debug info.
sencond param is sample.dat generated by ejtag cmd cpus 0 sample.dat.
third param is /tmp/loadmodule.txt generated by gdb in ejtag run modules cmd.


=cut

use Math::BigInt;
our %sym;
our %func;
our %pcs;
my $sign = hex(q(0xffffffff80000000));

$ENV{LC_ALL} = "C";

sub shex
{
 my $t = hex($_[0]);
 $t |= $sign if($t&0x80000000) ;
 return $t;
}

sub loadelf
{
my $F;
 open $F, qq(readelf -W -s $_[0]|);
 while(<$F>)
 {
  my @a = split /[:\s]+/, "t $_";
  {
   next if $a[7] eq q(UND) || $a[7] eq q(ABS);
   next if $a[4] ne q(OBJECT) && $a[4] ne q(FUNC);
   next if ! defined($a[8]);
   my $addr =  shex($a[2]);
   $a[3] = 4 if($a[3] == 0);
  $sym{$a[8]}= [ $addr, $a[3], $a[8], 0 ];
  for($i=$addr;$i<$addr+$a[3];$i+=4)
  {
  $func{$i} = $sym{$a[8]};
  }
  }
 }
  close $F;
}



sub loadmodule
{
#add-symbol-file /mnt/initrd/lib/modules/2.6.36.3-firewall+/extra/bridge/filter/ebt_802_3.ko 0 -s .note.gnu.build-id 0xf8 -s .text 0x0 -s .text.ebt_802_3_mt 0x0 -s .text.ebt_802_3_mt_check 0xb0 -s .exit.text 0xe4 -s .init.text 0x8000000000000000 -s .MIPS.options 0x120 -s .data 0x170 -s .gnu.linkonce.this_module 0x1f0 -s .bss 0x3f0
my %sec;

my @t = split /\s+/,$_[0];
my $f = $t[1];
my $F;

while($_[0]=~/-s (\S+) (0x\S+)/g)
{
 $sec{$1} = shex($2); 
}

open $F, qq(readelf -W -S $f|);
while(<$F>)
{
 if(/\[\s*(\d+)\]\s(\S+)/){
   $sec{$1} = $sec{$2};
 }
}
close $F;

 open $F, qq(readelf -W -s $f|);
 while(<$F>)
 {
  my @a = split /[:\s]+/, "t $_";
  {
   next if $a[7] eq q(UND) || $a[7] eq q(ABS);
   next if $a[4] ne q(OBJECT) && $a[4] ne q(FUNC);
   next if ! defined($a[8]);
   next if !$sec{$a[7]};
   my $addr = shex($a[2]) + $sec{$a[7]};
   $a[3] = 4 if($a[3] == 0);
  $sym{$a[8]}= [ $addr, $a[3], $a[8], 0 ];
  for($i=$addr;$i<$addr+$a[3];$i+=4)
  {
  $func{$i} = $sym{$a[8]};
  }
  }
 }
  close $F;

}

die q(file open error) if  ! -f $ARGV[0] || ! -f $ARGV[1];

loadelf qq($ARGV[0]);

if(@ARGV>2)
{
open F, $ARGV[2];
while(<F>)
{
 loadmodule $_;
}
close F;
}


open F,qq($ARGV[1]);
my $ret;
my $cnt;
my $pc;

do
{
	$ret = read F,$buf,4;
	if($ret == 4)
	{
		$pc = unpack(q(I),$buf);
		$pc |= $sign if($pc & 0x80000000);
		$pcs{$pc}++;
		$func{$pc}->[3]++;
	}
} while($ret == 4);
close F;

my @pcorder = sort {$pcs{$b} <=> $pcs{$a} } keys %pcs;

printf("-----------pc--------------\n");

for( @pcorder)
{
printf "%x %d %s+0x%x\n", $_,$pcs{$_}, $func{$_}->[2], $_-$func{$_}->[0];
}

printf("-----------func--------------\n");

my @funcorder = sort {$sym{$b}->[3] <=> $sym{$a}->[3] } keys %sym;
for( @funcorder)
{
last if !$sym{$_}->[3];
printf "%s %d\n", $_,$sym{$_}->[3];
}
__DATA__
while(<STDIN>)
{
eval "$_";
}
