BUILDDIR?=$(PWD)/
NOFIXUP=1
src?=$(PWD)
obj?=$(BUILDDIR)
export EXTRA_CFLAGS
export obj src NOFIXUP TOPDIR BUILDDIR

target ?= $(sort $(filter %.elf, $(patsubst %.elf64, %.elf, $(patsubst %.bin, %.elf, $(MAKECMDGOALS:.bin64=.bin)))))

$(foreach i,$(target),$(eval $($(basename $(i))-mk))$(sep))
ifdef BARCH
export BARCH
#VPATH = $(BARCH)
vpath %.c $(BARCH)
vpath %.S $(BARCH)
-include $(BARCH)/Makefile
endif
ifdef src
vpath %.c $(src)
vpath %.S $(src)
endif

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
AR = $(CROSS_COMPILE)ar
OBJCOPY = $(CROSS_COMPILE)objcopy

$(foreach i,$(target),$(eval $($(basename $(i))-mk1))$(sep))

define sep


endef

define elf_rules
$(1).elf: EXTRA_CFLAGS := $($(1)-cflags) $(EXTRA_CFLAGS) $($(1)-cflags1)

$(1).elf: bin1.lds $(src)/include/asm/asm-offsets32.h $($(1)-objs) $(foreach i,$($(1)-libs),lib$(i).a )
	${CROSS_COMPILE}ld  --emit-relocs -g -Map=map.txt -T  bin1.lds $(LDFLAGS) -o $$@ $($(1)-objs) -L . --start-group $(foreach i,$($(1)-libs),-l$(i) ) --end-group 

$(1).elf64: EXTRA_CFLAGS := $($(1)-cflags) $(EXTRA_CFLAGS) $($(1)-cflags1)

$(1).elf64: bin641.lds $(src)/include/asm/asm-offsets64.h $(patsubst %.o,%.o64,$(patsubst start%.o,start%64.o64,$($(1)-objs))) $(foreach i,$($(1)-libs),lib$(i)64.a )
	${CROSS_COMPILE}ld  --emit-relocs -g -Map=map.txt -T  bin641.lds $(LDFLAGS) -o $$@ $(patsubst %.o,%.o64,$(patsubst start%.o,start%64.o64,$($(1)-objs))) -L . --start-group $(foreach i,$($(1)-libs),-l$(i)64 ) --end-group 
endef

pkgcmd = $(foreach i,$(target),$(call elf_rules,$(basename $(i)))$(sep))
pkgcmd1 = $(foreach i,$(1),$(call elf_rules,$(basename $(i)))$(sep))

#$(call $(pkgcmd1), $(target))
$(eval $(pkgcmd))

bin1.lds: bin.lds.S
	${CROSS_COMPILE}gcc $(EXTRA_CFLAGS) -Umips -DLOADADDR=$(if $(LOADADDR),$(LOADADDR),0) -DMEMSIZE=$(MEMSIZE) -E -P -o $@ $<

bin641.lds: bin64.lds.S
	${CROSS_COMPILE}gcc $(EXTRA_CFLAGS) -Umips -DLOADADDR=$(if $(LOADADDR),$(LOADADDR),0) -DMEMSIZE=$(MEMSIZE) -E -P -o $@ $<

%.o %.o64: %.S
	make -f $(TOPDIR)/rules.make $@
%.o %.o64: %.c
	make -f $(TOPDIR)/rules.make $@

lib%.a lib%64.a: FORCE
	make -f $(TOPDIR)/rules.make $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@ 

%.bin64: %.elf64
	$(OBJCOPY) -O binary $< $@ 

$(src)/include/asm/asm-offsets64.h: $(obj)/asm-offsets.s64
	make -f $(TOPDIR)/rules.make $@

$(src)/include/asm/asm-offsets32.h: $(obj)/asm-offsets.s
	make -f $(TOPDIR)/rules.make $@

$(obj)/%.s64 %.s64: %.S
	make -f $(TOPDIR)/rules.make $@
$(obj)/%.s64 %.s64: %.c
	make -f $(TOPDIR)/rules.make $@

$(obj)/%.s %.s: %.S
	make -f $(TOPDIR)/rules.make $@
$(obj)/%.s %.s: %.c
	make -f $(TOPDIR)/rules.make $@

FORCE: ;

