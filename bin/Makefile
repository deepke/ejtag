TOPDIR=$(shell pwd)
BUILDDIR=$(TOPDIR)
obj=$(BUILDDIR)
src=$(TOPDIR)
bld=$(BUILDDIR)

export TOPDIR BUILDDIR obj src bld



all: clean allbins
ifeq ($(LOADADDR), )
	make LOADADDR=0 clean  elfs
	make LOADADDR=0 clean  elf64s
endif
	#make clean

testbin:
	gcc -o testbin testbin.c
clean:
	rm -f *.o *.s *.a testbin *.o64 *.s64 *.O *.O64 *.lds
	make -C lib clean
	make -C libm clean
	rm -rf libtinyc*
clean1:
	rm -f *.elf *.elf64 *.ELF *.ELF64
	make clean
cleanall:
	rm -f *.bin* *.bin64* *.BIN *.BIN64 *.bin-* *.BIN-* *.bin64-* *.BIN64-*
	make clean1

include rules.make
