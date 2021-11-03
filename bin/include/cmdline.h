#ifndef __CMDLINE_H__
#define __CMDLINE_H__
typedef struct cmd_struct {
	const char *cmdname;
	int (*func)(int, void *[]);
	int repeat;
	const char *usage;
	const char *expression;
} cmdline_t;

#define mycmd_init(name, func, repeat, usage, expression)  \
	    cmdline_t  __mycmd_##name __attribute__ ((unused,__section__ (".u_boot_cmd")))  = {#name,func,repeat, usage,expression};

#define mycmd_init1(name, name1, func, repeat, usage, expression)  \
	    cmdline_t  __mycmd_##name __attribute__ ((unused,__section__ (".u_boot_cmd")))  = {name1,func,repeat, usage,expression};
#define V_NUM	8	//the number of argv
#define V_LEN	15	//the length of argv
#define CMD_BUFF 64
int do_cmd(int argc, char **argv);
#endif
