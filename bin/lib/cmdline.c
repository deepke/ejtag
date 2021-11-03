/*
 * cmdline.c
 *	Use command to do testing, use "help" to get more information.
 *
 *  Created on: 2013-1-10
 *      Author: liming
 *      Author: QiaoChong
 */

#include <cmdline.h>

static char *prompt = "$ ";
int do_help(int argc, void *argv[]);
int do_d1(int argc, char **argv);
int do_m1(int argc, char **argv);

extern cmdline_t __u_boot_cmd_start[];
extern cmdline_t __u_boot_cmd_end[];

mycmd_init(help,do_help, 1, "help [command]","print cmd list");
mycmd_init(d1,do_d1, 1, "","d1/2/4/8 addr [count]");
mycmd_init(d2,do_d1, 1, "","d1/2/4/8 addr [count]");
mycmd_init(d4,do_d1, 1, "","d1/2/4/8 addr [count]");
#if __SIZEOF_LONG__ == 8
mycmd_init(d8,do_d1, 1, "","d1/2/4/8 addr [count]");
#endif
mycmd_init(m1,do_m1, 1, "","m1/2/4/8 addr [value]...");
mycmd_init(m2,do_m1, 1, "","m1/2/4/8 addr [value]...");
mycmd_init(m4,do_m1, 1, "","m1/2/4/8 addr [value]...");
#if __SIZEOF_LG__ == 8
mycmd_init(m8,do_m1, 1, "","m1/2/4/8 addr [value]...");
#endif
mycmd_init(exit,do_help, 0, "","exit");

int do_d1(int argc, char **argv)
{
	unsigned long addr, val;
	int i, num, size;
	if(argc < 2)
	{
		printf("\nusage: %s <addr> <num>", argv[0]);
		return 1;
	}
	addr = strtoul(argv[1],0,0);
	if(argc == 2) num = 1;
	else num = strtoul(argv[2],0,0);
	size = argv[0][1]-'0';

	for(i=0; i<num*size; i+=size)
	{
		if((i%16) == 0)
			printf("\n0x%08x:\t", addr+i);
		switch(size) {
		case 1:
			val = *(volatile unsigned char*)(addr+i);
		break;
		case 2:
			val = *(volatile unsigned short*)(addr+i);
		break;
		case 4:
			val = *(volatile unsigned int*)(addr+i);
		break;
#if __SIZEOF_LONG__ == 8
		case 8:
			val = *(volatile unsigned long long*)(addr+i);
		break;
#endif
		}
		printf(" %08lx ", val);
	}
	printf("\n");

	return 0;
}


int do_m1(int argc, char **argv)
{
	unsigned long addr;
	unsigned long value, size;
	int i;
	if(argc < 2)
	{
		printf("\nusage: m1 <addr> <value>");
		return 1;
	}
	addr = strtoul(argv[1],0,0);
	size = argv[0][1]-'0';
	for (i=2; i<argc; i++) { 
		value = strtoul(argv[i],0,0);
		switch(size) {
			case 1:
				*(volatile unsigned char*)(addr) = value;
				break;
			case 2:
				*(volatile unsigned short*)(addr) = value;
				break;
			case 4:
				*(volatile unsigned int*)(addr) = value;
				break;
#if __SIZEOF_LONG__ == 8
			case 8:
				*(volatile unsigned long*)(addr) = value;
				break;
#endif
		}
		addr += size;
	}

	return 0;
}

int do_help(int argc, void *argv[])
{
	char *s;
	cmdline_t *p;
	if(argc<2)
	{
		printf("\ncommands:\n\n");
		for(p = __u_boot_cmd_start;p != __u_boot_cmd_end; p++)
		{
			printf("%s,", p->cmdname);
		}
		printf("\b \b\n");
	}
	else
	{
		s = (char *)argv[1];
		for(p = __u_boot_cmd_start;p != __u_boot_cmd_end; p++)
		{
			if(strcmp(s, p->cmdname)==0)
			{
				printf("\n\t%s\t%s\t%s\n", p->cmdname, p->usage, p->expression);
				break;
			}
		}

	}

	return 0;
}

int do_cmd(int argc, char **argv)
{
	cmdline_t *p, *best = NULL;
	int i, repeat, ll = 0;
	if (!argc)
		return do_help(argc, argv);
	for(p = __u_boot_cmd_start;p != __u_boot_cmd_end; p++)
	{
		if(strcmp(argv[0], p->cmdname)==0)
		{
			p->func(argc, argv);
			return p->repeat;
		} else {
			int l = strlen(p->cmdname);
			if ( l >= ll && strncmp(argv[0], p->cmdname, l) == 0) {
				best = p ;
				ll = l;
			}
		}
	}

	if (best) {
		best->func(argc, argv);
		return best->repeat;
	} else
		printf("ERROR: undefine command!!!\n");
	  return -1;
}

/*The format of cmd is "$xxx xx xx xx". */
int cmdloop(void)
{
	char c;
	char cmdbuffer[CMD_BUFF]={0};
	int (*op)(int argc, void *argv[]);
	int argc;
	char *argv[V_NUM]={0};
	char *cmdptr;
	short cp, i;
	int repeat = 0;

	while(1)
	{
		printf(prompt);
		cp = 0;  //current position

		while(cp<CMD_BUFF-1)   // internal loop
		{
			c = getchar();
			if((c>0x1f)&&(c<0x7f))  //no ctrl_char
			{
				cmdbuffer[cp++] = c;
				putchar(c);
			}
			else if((c == 0x8 || c == 0x7f) && cp) //backspace
			{
				cp--;
				cmdbuffer[cp] = '\0';
				putchar(0x8);
				putchar(0x20);  //This is an interesting way.
				putchar(0x8);
			}
			else if((c==0xa) || (c==0xd))
			{
				printf("\r\n");
				break;
			}
		}

		if(cp == 0)
		{
			if(!argv[0] || !repeat)
				continue;
		}
		else
		{
			char *p0;
			char c0, c;
			for(i=0, argc=0, p0=cmdbuffer, c0=0; i<cp; i++)
			{
				if((c = cmdbuffer[i]) == 0x20)  //space
				{
					cmdbuffer[i] = 0;
				}
				else if(c0==0x20)
				{
					argv[argc++] = p0;
					p0 = cmdbuffer+i;
				}

				c0 = c;
			}

			if(c0!=0x20) argv[argc++] = p0;
			cmdbuffer[i] = 0;
		}

		if(strcmp(argv[0], "exit")==0) break;  //exit
		else
			repeat = do_cmd(argc, argv) > 0;
	}
	return 0;
}	

int cmd_set_prompt(char *newprompt)
{
	prompt = newprompt;
	return 0;
}
