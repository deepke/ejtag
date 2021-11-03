.SUFFIXES: .o64 .elf64 .bin64

objs= memset.o printf.o udelay.o now.o putchar.o puts.o printhex.o  printbase.o memcmp.o strcat.o strchr.o strcmp.o strtok.o strspn.o strcspn.o getchar.o testchar.o vsprintf.o atob.o sprintf.o strtoupp.o toupper.o str_fmt.o strcpy.o strlen.o strichr.o strlen.o  strncmp.o strncpy.o printf.o sprintbase.o tprintf.o dtprintf.o tsprintf.o tsnprintf.o tvsnprintf.o malloc.o cmdline.o strtoul.o calloc.o strstr.o pmalloc.o strrchr.o dumpmem.o qsort.o atof.o strtol.o ctype.o tlb.o time.o pbmalloc.o crc32.o crc16.o realloc.o
ifeq "$(shell echo $(CFLAGS)|grep  'march=loongson3a')" ""
objs += memcpy.o
else
objs += loongson3-memcpy.o
endif

clean:
	rm -f *.o *.a *.s *.o64 *.bin64 *.elf64


include $(TOPDIR)/rules.make
objs64  := $(subst memcpy, loongson3_memcpy, $(objs64))
