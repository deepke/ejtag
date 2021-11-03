/* fix-nop.c
 * Heihaier - admin@heihaier.org
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <elf.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define INSN_ORIG		0x00000000
#define INSN_FIXED		0x00200825	/* or at,at,zero */

struct module
{
int init_text_size;
int init_size;
int init_ro_size;
int core_text_size;
int core_size;
int core_ro_size;
unsigned long long module_core;
unsigned long long module_init;
} module;

int config_kallsyms;

#define DEBUGP(...) //printf


#ifndef ARCH_SHF_SMALL
#define ARCH_SHF_SMALL 0
#endif

#define INIT_OFFSET_MASK(n) (1ULL << (n-1))

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
#define debug_align(x) (x)


#define get_offset(n) static long get_offset##n(unsigned int *size, Elf##n ##_Shdr *sechdr) \
{ \
	long ret; \
 \
	ret = ALIGN(*size, sechdr->sh_addralign ?: 1); \
	*size = ret + sechdr->sh_size; \
	return ret; \
} 

#define layout_sections(n) static void layout_sections##n(struct module *mod, \
			    const Elf##n ##_Ehdr *hdr, \
			    Elf##n ##_Shdr *sechdrs)\
{ \
	unsigned long const masks[][2] = { \
		/* NOTE: all executable code must be the first section \
		 * in this array; otherwise modify the text_size \
		 * finder in the two loops below */ \
		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL }, \
		{ SHF_ALLOC, SHF_WRITE | ARCH_SHF_SMALL }, \
		{ SHF_WRITE | SHF_ALLOC, ARCH_SHF_SMALL }, \
		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 } \
	}; \
	unsigned int m, i; \
	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset; \
	int symindex, strindex, infoindex, versindex;\
	for (i = 0; i < hdr->e_shnum; i++) \
	{\
		if (sechdrs[i].sh_type == SHT_SYMTAB) \
		{\
			symindex = i;\
			strindex = sechdrs[i].sh_link;\
		}\
\
		if(!strcmp(secstrings + sechdrs[i].sh_name, ".modinfo"))\
			infoindex = i;\
\
		if(!strcmp(secstrings + sechdrs[i].sh_name, "__versions"))\
			versindex = i;\
        }\
	/* Don't keep modinfo and version sections. */\
	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;\
	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;\
\
	if(config_kallsyms)\
	{\
	/* Keep symbol and string tables for decoding later. */\
	sechdrs[symindex].sh_flags |= SHF_ALLOC;\
	sechdrs[strindex].sh_flags |= SHF_ALLOC;\
	}\
 \
	for (i = 0; i < hdr->e_shnum; i++) \
		sechdrs[i].sh_entsize = ~0; \
 \
	DEBUGP("Core section allocation order:\n"); \
	for (m = 0; m < ARRAY_SIZE(masks); ++m) { \
		for (i = 0; i < hdr->e_shnum; ++i) { \
			Elf##n ##_Shdr *s = &sechdrs[i]; \
DEBUGP("%s flag %x %x %x %x %x \n", secstrings + sechdrs[i].sh_name, s->sh_flags,(s->sh_flags & masks[m][0]) != masks[m][0],(s->sh_flags & masks[m][1]),s->sh_entsize != ~0,strncmp(secstrings + s->sh_name, \
                                       ".init", 5) == 0); \
 \
			if ((s->sh_flags & masks[m][0]) != masks[m][0] \
			    || (s->sh_flags & masks[m][1]) \
			    || s->sh_entsize != ~0 \
			    || strncmp(secstrings + s->sh_name, \
				       ".init", 5) == 0) \
				continue; \
			s->sh_entsize = get_offset##n(&mod->core_size, s); \
			DEBUGP("\t%s\n", secstrings + s->sh_name); \
		} \
		switch (m) {\
		case 0: /* executable */\
			mod->core_size = debug_align(mod->core_size);\
			mod->core_text_size = mod->core_size;\
			break;\
		case 1: /* RO: text and ro-data */\
			mod->core_size = debug_align(mod->core_size);\
			mod->core_ro_size = mod->core_size;\
			break;\
		case 3: /* whole core */\
			mod->core_size = debug_align(mod->core_size);\
			break;\
		}\
	} \
 \
	DEBUGP("Init section allocation order:\n"); \
	for (m = 0; m < ARRAY_SIZE(masks); ++m) { \
		for (i = 0; i < hdr->e_shnum; ++i) { \
			Elf##n ##_Shdr *s = &sechdrs[i]; \
 \
			if ((s->sh_flags & masks[m][0]) != masks[m][0] \
			    || (s->sh_flags & masks[m][1]) \
			    || s->sh_entsize != ~0 \
			    || strncmp(secstrings + s->sh_name, \
				       ".init", 5) != 0) \
				continue; \
			DEBUGP("\t%s init_size=0x%x\n", secstrings + s->sh_name, mod->init_size); \
			s->sh_entsize = (get_offset##n(&mod->init_size, s) \
					 | INIT_OFFSET_MASK(n)); \
			DEBUGP("\t%s init_size=0x%x 0x%x\n", secstrings + s->sh_name,mod->init_size, s->sh_entsize); \
		} \
		switch (m) {\
		case 0: /* executable */\
			mod->init_size = debug_align(mod->init_size);\
			mod->init_text_size = mod->init_size;\
			break;\
		case 1: /* RO: text and ro-data */\
			mod->init_size = debug_align(mod->init_size);\
			mod->init_ro_size = mod->init_size;\
			break;\
		case 3: /* whole init */\
			mod->init_size = debug_align(mod->init_size);\
			break;\
		}\
	} \
	{ \
	unsigned long long textaddr = 0; \
	for (i = 0; i < hdr->e_shnum; i++) \
	if(!strcmp(secstrings + sechdrs[i].sh_name,".text")) \
	{\
	 textaddr = mod->module_core + sechdrs[i].sh_entsize;\
	 break;\
	}\
	printf(" 0x%llx ", textaddr);\
	for (i = 0; i < hdr->e_shnum; i++) \
		if(sechdrs[i].sh_entsize!=~0){\
		 if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK(n)) \
		 printf("-s %s 0x%llx ",secstrings + sechdrs[i].sh_name, mod->module_init + (sechdrs[i].sh_entsize & ~INIT_OFFSET_MASK(n))); \
		 else \
		 printf("-s %s 0x%llx ",secstrings + sechdrs[i].sh_name, mod->module_core + sechdrs[i].sh_entsize); \
		}\
	}\
} 

#define BITS_PER_LONG 32
get_offset(32)
layout_sections(32)

#undef BITS_PER_LONG
#define BITS_PER_LONG 64
get_offset(64)
layout_sections(64)


int main(int argc, char *argv[])
{
	int elf_file;
	struct stat sb;

	if (argc != 4 && argc != 5) {
		printf("Usage: load-module modulefile coreaddr initaddr\n");
		return -1;
	}

	if(argc == 5) config_kallsyms = strtoul(argv[4],0,0);

	elf_file = open(argv[1], O_RDONLY);
	if (-1 == elf_file) {
		printf("ERROR: open %s failed!\n", argv[1]);
		return -1;
	}

	fstat(elf_file, &sb);
	void *p = mmap(NULL, sb.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE,
		       elf_file, 0);
	if (MAP_FAILED == p) {
		printf("ERROR: mmap failed!\n");
		return -1;
	}

	if ((((unsigned char *)p)[EI_MAG0] != ELFMAG0) ||
	    (((unsigned char *)p)[EI_MAG1] != ELFMAG1) ||
	    (((unsigned char *)p)[EI_MAG2] != ELFMAG2) ||
	    (((unsigned char *)p)[EI_MAG3] != ELFMAG3)) {
		printf("ERROR: %s isn't elf file.\n", argv[1]);
		return -1;
	}

	module.module_core = strtoull(argv[2],0,0);
	module.module_init = strtoull(argv[3],0,0);
	printf("add-symbol-file %s ", argv[1]);



	if (((unsigned char *)p)[EI_CLASS] == ELFCLASS32)
		layout_sections32(&module, (Elf32_Ehdr *)p, (Elf32_Shdr *) (p + ((Elf32_Ehdr *)p)->e_shoff));
	else if (((unsigned char *)p)[EI_CLASS] == ELFCLASS64)
		layout_sections64(&module, (Elf64_Ehdr *)p, (Elf64_Shdr *) (p + ((Elf64_Ehdr *)p)->e_shoff));
	printf("\n");

	munmap(p, sb.st_size);
	close(elf_file);

	return 0;
}
