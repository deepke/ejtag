#!/usr/bin/perl
use bignum;
unshift @INC,qq(./scripts);
require qq(io.pm);

$can0 = 0xffffffffbfe00c00;
$can1 = 0xffffffffbfe00d00;
$canid = 0x83;
$dlc = 8;
$rtr = 0;
$mode_ext = 1;

sub CAN0_BASE()
{
	return $can0;
}

sub CAN1_BASE()
{
	return $can1;
}


sub extern_testself_1()  
{
#reset mode
outb(CAN0_BASE,1);
outb(CAN1_BASE,1);
# externmode	
outb(CAN0_BASE+1,0x80);#gc
outb(CAN1_BASE+1,0x80);#gc
#set timing
outb(CAN0_BASE+6,3+(1<<6)); #gc3+(1<<6)   43
outb(CAN0_BASE+7,0x2f);  #gc2f  0xf+(0x2<<4)+(0<<7)
outb(CAN1_BASE+6,3+(1<<6)); #gc3+(1<<6)   43
outb(CAN1_BASE+7,0x2f);  #gc2f  0xf+(0x2<<4)+(0<<7)
outb(CAN0_BASE+5,0xff);  #gcff  mask == ff
#outb(CAN1_BASE+5,0xff);  #gcff  mask == ff

outb(CAN0_BASE+16,0x0);
outb(CAN0_BASE+17,0x0);   #gc 这几个寄存器的功能？怎么设置.id帧
outb(CAN0_BASE+18,0x0);
outb(CAN0_BASE+19,0x0);
outb(CAN0_BASE+20,0xff);
outb(CAN0_BASE+21,0xff);
outb(CAN0_BASE+22,0xff);
outb(CAN0_BASE+23,0xff);

outb(CAN1_BASE+16,0x0);
outb(CAN1_BASE+17,0x0);   #gc 这几个寄存器的功能？怎么设置.id帧
outb(CAN1_BASE+18,0x0);
outb(CAN1_BASE+19,0x0);
outb(CAN1_BASE+20,0xff);
outb(CAN1_BASE+21,0xff);
outb(CAN1_BASE+22,0xff);
outb(CAN1_BASE+23,0xff);

outb(CAN0_BASE+4,0xff);  #gc 所有中断 使能
outb(CAN1_BASE+4,0xff);  #gc 所有中断 使能
#work mode
outb(CAN0_BASE,0x4); #gc04正常工作模式
outb(CAN1_BASE,0x4); #gc04正常工作模式
#set data
outb(CAN0_BASE+16,0x88);  #gcID 
outb(CAN0_BASE+17,0x12);
outb(CAN0_BASE+18,0x34);
outb(CAN0_BASE+19,0x45);
outb(CAN0_BASE+20,0x56);   #gc接收时，变0x50

outb(CAN0_BASE+21,0x1);
outb(CAN0_BASE+22,0x2);
outb(CAN0_BASE+23,0x3);
outb(CAN0_BASE+24,0x4);
outb(CAN0_BASE+25,0x5);
outb(CAN0_BASE+26,0x6);
outb(CAN0_BASE+27,0x7);
outb(CAN0_BASE+28,0x8);
#

#outb(CAN0_BASE+1,0x90);  #self request ok now
outb(CAN0_BASE+1,0x81);  #gctx_requeste
printf("wait..\n");
<STDIN>;
do_cmd("d4 0x%x 8\n",CAN1_BASE);
do_cmd("d4 0x%x 8\n",CAN0_BASE);
printf("\n");
outb(CAN1_BASE+1,0x84); #release buffer
outb(CAN0_BASE+1,0x84); #release buffer

}


#========================================== 扩展模式，can0 自己发，自己收. can1也一样, ok
# 能够接收数据 但是，outb(CAN0_BASE+20,0x56); 收到0x50.不是0x56

sub extern_testself_2()
{
#reset mode
outb(CAN0_BASE,1);
outb(CAN1_BASE,1);
#outb(CAN0_BASE+31,0x80);
# externmode
outb(CAN0_BASE+1,0x90);#gc自接收请求

#set timing
outb(CAN0_BASE+6,3+(1<<6)); #gc3+(1<<6)   43
outb(CAN0_BASE+7,0x2f);  #gc2f  0xf+(0x2<<4)+(0<<7)
outb(CAN0_BASE+5,0xff);  #gcff  mask == ff

outb(CAN0_BASE+16,0x0);
outb(CAN0_BASE+17,0x0);   #gc 这几个寄存器的功能？怎么设置.id帧
outb(CAN0_BASE+18,0x0);
outb(CAN0_BASE+19,0x0);
outb(CAN0_BASE+20,0xff);
outb(CAN0_BASE+21,0xff);
outb(CAN0_BASE+22,0xff);
outb(CAN0_BASE+23,0xff);

outb(CAN0_BASE+4,0xff);  #gc 所有中断 使能
#work mode
outb(CAN0_BASE,0x04); #gc04正常工作模式
#set data
outb(CAN0_BASE+16,0x88);  #gcID 
outb(CAN0_BASE+17,0x12);
outb(CAN0_BASE+18,0x34);
outb(CAN0_BASE+19,0x45);
outb(CAN0_BASE+20,0x56);

outb(CAN0_BASE+21,0x1);
outb(CAN0_BASE+22,0x2);
outb(CAN0_BASE+23,0x3);
outb(CAN0_BASE+24,0x4);
outb(CAN0_BASE+25,0x5);
outb(CAN0_BASE+26,0x6);
outb(CAN0_BASE+27,0x7);
outb(CAN0_BASE+28,0x8);
#release buffer
outb(CAN0_BASE+1,0x94);
outb(CAN0_BASE+1,0x90);  #gctx_requeste
printf("wait..\n");
<STDIN>;
do_cmd("d4 0x%x 8\n",CAN1_BASE);
printf("\n");
}

sub hello2()  #gc  2个脚can0_h--can1_h,can0_l--can1_l链接,
		 #gc  标准模式:can0_tx and can1_rx.  ok 
{
	
#reset mode
outb(CAN1_BASE,1);
#leave externmode
outb(CAN1_BASE+1,0);
#set timing
outb(CAN1_BASE+6,3+(1<<6)); #gc3+(1<<6)  0x43
outb(CAN1_BASE+7,0xf+(0x2<<4)+(0<<7));  #gc 0x2f

outb(CAN1_BASE+0x4,0xa5); #gc== outb(CAN0_BASE+10,0xa5)
outb(CAN1_BASE+0x5,0xff);
#work mode
outb(CAN1_BASE,0);


#reset mode
outb(CAN0_BASE,1);
#leave externmode
outb(CAN0_BASE+1,0);
#set timing
outb(CAN0_BASE+6,3+(1<<6)); #gc3+(1<<6)    0x43
outb(CAN0_BASE+7,0xf+(0x2<<4)+(0<<7)); #gc 0x2f

outb(CAN0_BASE+0x4,0xa5); #gc acr  == outb(CAN0_BASE+10,0xa5)
outb(CAN0_BASE+0x5,0xff); #gc amr  mask
#work mode
outb(CAN0_BASE,0);
#set data
outb(CAN0_BASE+10,0xa5);
outb(CAN0_BASE+11,0x28);
outb(CAN0_BASE+12,0x1);
outb(CAN0_BASE+13,0x2);
outb(CAN0_BASE+14,0x3);
outb(CAN0_BASE+15,0x4);
outb(CAN0_BASE+16,0x5);
outb(CAN0_BASE+17,0x6);
outb(CAN0_BASE+18,0x7);
outb(CAN0_BASE+19,0x8);
print("release can1 buffer");
outb(CAN1_BASE+1,0x4); #release buffer
do_cmd("d1 0x%x 10\n",CAN1_BASE+0x14);
print("can1 status\n");
do_cmd("d1 0x%x 1\n",CAN1_BASE+2);
printf("press to send\n");
<STDIN>;
outb(CAN0_BASE+1,0x1);  #gctx_requeste


<STDIN>;
print("can0 tx buffer");
do_cmd("d1 0x%x 10\n",CAN0_BASE+10);
print("can1 rx buffer");
do_cmd("d1 0x%x 10\n",CAN1_BASE+0x14);
print("can1 status\n");
do_cmd("d1 0x%x 1\n",CAN1_BASE+2);
printf("\n");
#release buffer
outb(CAN1_BASE+1,0x4); #release buffer

}


sub sw_clk_init{
outb($_[0]+6,3+(1<<6)); #gc3+(1<<6)  0x43
outb($_[0]+7,0xf+(0x2<<4)+(0<<7));  #gc 0x2f
}

sub sw_id_mask_init{
	if($mode_ext)
	{
		outb($_[0]+16,$canid);
		outb($_[0]+17,($canid>>8)&0xff);
		outb($_[0]+18,($canid>>16)&0xff);
		outb($_[0]+19,($canid>>24)&0xff);
		outb($_[0]+20,0xff);
		outb($_[0]+21,0xff);
		outb($_[0]+22,0xff);
		outb($_[0]+23,0xff);
	}
	else
	{
		outb($_[0]+4,$canid);
		outb($_[0]+5,0xff);
	}
}

sub sw_normal_mode{
	if($mode_ext)
	{
		outb($_[0],0x0);
	}
	else
	{
		outb($_[0],0x1e);
	}
}

sub sw_listen_mode{
	if($mode_ext)
	{
		outb($_[0],2);
	}
	else
	{
		outb($_[0],0x0);
	}
}

sub sw_reset_mode{
	if($mode_ext)
	{
		outb($_[0],0x1);
		outb($_[0]+1,0x80);
	}
	else
	{
		outb($_[0],0x1);
		outb($_[0]+1,0x0);
	}
}

sub sw_setup_txframe{
	if($mode_ext)
	{
		my @d=(($rtr<<5)|$dlc, ($canid>>3)&0xff, ($canid&7)<<5, 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xa);
		my $i=16;
		for (@d)
		{
			outb($_[0]+$i++,$_);
		}
	}
	else
	{
		my @d=(($canid>>3)&0xff,(($canid&7)<<5)|($rtr<<4)|$dlc,0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8);
		my $i=10;
		for (@d)
		{
			outb($_[0]+$i++,$_);
		}
	}
}

sub can_send
{
	if($mode_ext)
	{
		outb($_[0]+1,0x81);
	}
	else
	{
		outb($_[0]+1,0x1);  #gctx_requeste
	}
}


sub sw_release_buffer
{
	if($mode_ext)
	{
		outb($_[0]+1,0x84); #release buffer
		do_cmd("d1 0x%x 10\n",$_[0]+16);
	}
	else
	{
		outb($_[0]+1,0x4); #release buffer
		do_cmd("d1 0x%x 10\n",$_[0]+20);
	}
}

sub can_status
{
        do_cmd("d1 0x%x 2\n",$_[0]+2);
}


sub can_tx_display
{
	if($mode_ext)
	{
	print("extend mode can not read tx buffer\n");
	}
	else
	{
        do_cmd("d1 0x%x 10\n",$_[0]+10);
	}
}


sub can_rx_display
{
	if($mode_ext)
	{
		do_cmd("d1 0x%x 13\n",$_[0]+16);
		do_cmd("d1 0x%x 1\n",$_[0]+29);
	}
	else
	{
		do_cmd("d1 0x%x 10\n",$_[0]+20);
	}
}

sub sw_can{
	sw_reset_mode(CAN0_BASE);
	sw_reset_mode(CAN1_BASE);
	sw_clk_init(CAN0_BASE);
	sw_clk_init(CAN1_BASE);
	sw_id_mask_init(CAN0_BASE);
	sw_id_mask_init(CAN1_BASE);
	sw_normal_mode(CAN0_BASE);
	sw_normal_mode(CAN1_BASE);
	sw_listen_mode(CAN1_BASE);
	sw_setup_txframe(CAN0_BASE);
        print("can0 tx buffer");
        can_tx_display(CAN0_BASE);

        print("release can1 buffer");
        sw_release_buffer(CAN1_BASE);
        print("can1 status\n");
        can_status(CAN1_BASE);
        printf("press to send\n");
        <STDIN>;
        can_send(CAN0_BASE);
        <STDIN>;
        print("can1 rx buffer");
        can_rx_display(CAN1_BASE);
        print("can1 status\n");
        can_status(CAN1_BASE);
        printf("\n");
        #release buffer
        print("release buffer\n");
        sw_release_buffer(CAN1_BASE);
}


sub ls2k_can_send{
	$can0 = 0xffffffffbfe00c00;
	$can1 = 0xffffffffbfe00d00;
	outl(0xffffffffbfe00420,inl(0xffffffffbfe00420)|(3<<16));
	sw_reset_mode(CAN0_BASE);
	sw_clk_init(CAN0_BASE);
	sw_id_mask_init(CAN0_BASE);
	sw_normal_mode(CAN0_BASE);
	sw_setup_txframe(CAN0_BASE);
        can_send(CAN0_BASE);
        <STDIN>;
        print("can0 tx buffer");
        can_tx_display(CAN0_BASE);
}

sub ls2k_can_recv{
	$can0 = 0xffffffffbfe00c00;
	$can1 = 0xffffffffbfe00d00;
	outl(0xffffffffbfe00420,inl(0xffffffffbfe00420)|(3<<16));

	sw_reset_mode(CAN1_BASE);
	sw_clk_init(CAN1_BASE);
	sw_id_mask_init(CAN1_BASE);
	sw_normal_mode(CAN1_BASE);
	outb(CAN1_BASE+1,0x0); # only listen
	print qq(wait..\n);
	<STDIN>;
        print("can1 rx buffer");
        can_rx_display(CAN1_BASE);
}


do_cmd("echo_on");
#ls2k_can_recv
#ls2k_can_send
outl(0xffffffffbfe10420,inl(0xffffffffbfe10420)|(3<<16));
sw_can;
#hello2;
#extern_testself_1
#extern_testself_2

