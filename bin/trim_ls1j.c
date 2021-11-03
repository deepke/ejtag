#define ERASE_CMD  0xa0000000
#define PAGE_CMD   0xe0000000
#define CLRPL_CMD  0x40000000
#define INTCLR_CMD 0x30000000

#define FLASH_BASE      0xa0002000

#define CMD      *(volatile unsigned int*)(FLASH_BASE + 0x0)
#define STATUS   *(volatile unsigned int*)(FLASH_BASE + 0x4)
#define PE_MODE  *(volatile unsigned int*)(FLASH_BASE + 0x8)
#define ACCGATE  *(volatile unsigned int*)(FLASH_BASE + 0x10)

unsigned int crc_ccitt(unsigned c, unsigned d)
{
    unsigned e = (c ^ d) & 0xff;
    unsigned f = (e ^ (e<<4)) & 0xff;

    unsigned cc = ((c>>8) ^ (f<<8) ^ (f<<3) ^ (f>>4)) & 0xffff;

    unsigned ee = (cc ^ (d>>8)) & 0xff;
    unsigned ff = (ee ^ (ee<<4)) & 0xff;

    unsigned r = ((cc>>8) ^ (ff<<8) ^ (ff<<3) ^ (ff>>4)) & 0xffff;

    return r;
}

#define MYDBG printf("%s:%d\n", __FUNCTION__, __LINE__);

int trim()
{
    unsigned vdtrim_c, vdtrim_cl;
    unsigned S, Pdac, Ndac, itim;
    unsigned Bdac, tctrim, abstrim;
    unsigned trim1, trim2, trim3, trim4, trim5;
    unsigned crc = 0xffff;
MYDBG
// unlock
    ACCGATE = 0xc6b80b65;   
    ACCGATE = 0x2d242763;
    ACCGATE = 0x14efc826;
    ACCGATE = 0x4fc52bbc;
//
    PE_MODE = 0xc0000000 | PE_MODE; // lucid write

MYDBG
	trim1 = *(volatile unsigned *)(0xbf0101ec);
	trim2 = *(volatile unsigned *)(0xbf0101f0);
	trim3 = *(volatile unsigned *)(0xbf0101f4);

	vdtrim_c 	= (trim1 >>  0) & 0xff;
	vdtrim_cl	= (trim1 >>  8) & 0xff;
	S		= (trim2 >>  0) & 0xff;
	Pdac		= (trim2 >>  8) & 0xff;
	Ndac		= (trim2 >> 16) & 0xff;
	itim		= (trim2 >> 24) & 0xff;
	Bdac		= (trim3 >>  0) & 0xff;
	tctrim     	= (trim3 >>  8) & 0xff;
	abstrim		= (trim3 >> 16) & 0xff;
	printf("vdtrim_c  : %x\n",vdtrim_c);
	printf("vdtrim_cl : %x\n",vdtrim_cl);
	printf("S         : %x\n",S);
	printf("Pdac      : %x\n",Pdac);
	printf("Ndac      : %x\n",Ndac);
	printf("itim      : %x\n",itim);
	printf("Bdac      : %x\n",Bdac);
	printf("tctrim    : %x\n",tctrim);
	printf("abstrim   : %x\n",abstrim);

        trim1 = vdtrim_c | (vdtrim_cl<<8);
        trim2 = S | (Pdac <<8); 
        trim3 = Ndac | (itim <<8);
        trim4 = Bdac | (tctrim <<8); 
        trim5 = abstrim;
        
        crc = crc_ccitt(crc, trim1);
        crc = crc_ccitt(crc, trim2);
        crc = crc_ccitt(crc, trim3);
        crc = crc_ccitt(crc, trim4);
        crc = crc_ccitt(crc, trim5);

        trim2 = trim2 | (trim3 << 16);
        trim3 = trim4 | (trim5 << 16);

        PE_MODE = 0x18;
        CMD = ERASE_CMD | 0x8040;
        CMD = ERASE_CMD | 0x8080;
        CMD = CLRPL_CMD;
        *(volatile unsigned *)(0xbf008040) = trim1;
        *(volatile unsigned *)(0xbf008044) = trim2;
        *(volatile unsigned *)(0xbf008048) = trim3;
        *(volatile unsigned *)(0xbf00804c) = crc;
        *(volatile unsigned *)(0xbf008050) = 0;
        *(volatile unsigned *)(0xbf008054) = 0;
        *(volatile unsigned *)(0xbf008058) = 0;
        *(volatile unsigned *)(0xbf00805c) = 0;
        *(volatile unsigned *)(0xbf008060) = 0;
        *(volatile unsigned *)(0xbf008064) = 0;
        *(volatile unsigned *)(0xbf008068) = 0;
        *(volatile unsigned *)(0xbf00806c) = 0;
        *(volatile unsigned *)(0xbf008070) = 0;
        *(volatile unsigned *)(0xbf008074) = 0;
        *(volatile unsigned *)(0xbf008078) = 0;
        *(volatile unsigned *)(0xbf00807c) = 0;
        CMD = PAGE_CMD | 0x8040;
        CMD = CLRPL_CMD;
        *(volatile unsigned *)(0xbf008080) = trim1;
        *(volatile unsigned *)(0xbf008084) = trim2;
        *(volatile unsigned *)(0xbf008088) = trim3;
        *(volatile unsigned *)(0xbf00808c) = crc;
        *(volatile unsigned *)(0xbf008090) = 0;
        *(volatile unsigned *)(0xbf008094) = 0;
        *(volatile unsigned *)(0xbf008098) = 0;
        *(volatile unsigned *)(0xbf00809c) = 0;
        *(volatile unsigned *)(0xbf0080a0) = 0;
        *(volatile unsigned *)(0xbf0080a4) = 0;
        *(volatile unsigned *)(0xbf0080a8) = 0;
        *(volatile unsigned *)(0xbf0080ac) = 0;
        *(volatile unsigned *)(0xbf0080b0) = 0;
        *(volatile unsigned *)(0xbf0080b4) = 0;
        *(volatile unsigned *)(0xbf0080b8) = 0;
        *(volatile unsigned *)(0xbf0080bc) = 0;
        CMD = PAGE_CMD | 0x8080;

MYDBG
        printf("\n trim1 = %4x",trim1);
        printf("\n trim2 = %4x",trim2);
        printf("\n trim3 = %4x",trim3);
        printf("\nwrite trimming done\n");    

    return 0;
}

int mymain()
{
MYDBG
	trim();
MYDBG
   
    return 0;
}

