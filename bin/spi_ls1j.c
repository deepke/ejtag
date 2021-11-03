#define ERASE_CMD  0xa0000000
#define PAGE_CMD   0xe0000000
#define CLRPL_CMD  0x40000000
#define INTCLR_CMD 0x30000000

#define FLASH_BASE      0xa0002000

#define CMD      *(volatile unsigned int*)(FLASH_BASE + 0x0)
#define STATUS   *(volatile unsigned int*)(FLASH_BASE + 0x4)
#define PE_MODE  *(volatile unsigned int*)(FLASH_BASE + 0x8)

int copy_to_flash(unsigned char *src, unsigned int offset, unsigned int size)
{
    unsigned int data;
    unsigned int start = offset;
    unsigned int end = offset + size;

    printf("\n start page\n");
    PE_MODE = 0x18;
    CMD = CLRPL_CMD;
    for(offset = start; offset < end; offset +=4)                           // 32kB
    {
        data = *(volatile unsigned int*)(src + offset);    // src
        *(volatile unsigned int*)(0xbf000000 + offset) = data;    // dst
        
        if(offset % 0x40 == 0x3c)
        {
            CMD = ERASE_CMD | offset;
            CMD = PAGE_CMD  | offset;
            CMD = CLRPL_CMD;
            printf(".");
        }
        if(offset % 0x400 == 0) printf("\n");
    }
    printf("\nbegin check\n");
    for(offset = start; offset < end; offset +=4)
    {
        data = *(volatile unsigned *)(src + offset);
        if(data != *(volatile unsigned *)(0xbf000000 + offset)) printf(" err @ %x\n",offset);
    }
    printf("check done\n");
    return 0;
}

int mymain(unsigned char *src, unsigned int offset, unsigned int size)
{
	int argc = *(int *)ARGC_REG;

	if(argc != 3)
	{ 
		printf("usage : ramaddr flashoffset size\n");
	}

	copy_to_flash(src, offset, size);
   
    return 0;
}

