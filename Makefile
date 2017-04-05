#
# Binary loader for BMIPS CFE based boards
# Copyright (C) 2017 Álvaro Fernández Rojas <noltari@gmail.com>
#
# Some parts of this file was based on the LZMA compressed kernel loader
# for Broadcom BMIPS based boards:
#	Copyright (C) 2014 Jonas Gorski <jogo@openwrt.org>
#
# Some parts of this file was based on the LZMA compressed kernel loader
# for Atheros AR7XXX/AR9XXX based boards:
#	Copyright (C) 2011 Gabor Juhos <juhosg@openwrt.org>
#
# Some parts of this file was based on the OpenWrt specific lzma-loader
# for the BCM47xx and ADM5120 based boards:
#	Copyright (C) 2004 Manuel Novoa III (mjn3@codepoet.org)
#	Copyright (C) 2005 Mineharu Takahara <mtakahar@yahoo.com>
#	Copyright (C) 2005 by Oleg I. Vdovikin <oleg@cs.msu.su>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#

LOADADDR	:= 0x80010000
BIN_TEXT_START	:= 0x80a00000
LOADER_DATA	:=
CACHELINE_SIZE	:= 16

CC		:= $(CROSS_COMPILE)gcc
LD		:= $(CROSS_COMPILE)ld
OBJCOPY		:= $(CROSS_COMPILE)objcopy
OBJDUMP		:= $(CROSS_COMPILE)objdump

BIN_FLAGS	:= -O binary -R .reginfo -R .note -R .comment -R .mdebug \
		   -R .MIPS.abiflags -S

CFLAGS		= -D__KERNEL__ -Wall -Wstrict-prototypes -Wno-trigraphs -Os \
		  -fno-strict-aliasing -fno-common -fomit-frame-pointer -G 0 \
		  -mno-abicalls -fno-pic -ffunction-sections -pipe \
		  -ffreestanding -fhonour-copts \
		  -mabi=32 -march=mips32 \
		  -Wa,-32 -Wa,-march=mips32 -Wa,-mips32 -Wa,--trap \
		  -DCONFIG_CACHELINE_SIZE=$(CACHELINE_SIZE)

ASFLAGS		= $(CFLAGS) -D__ASSEMBLY__

LDFLAGS		= -static --gc-sections -no-warn-mismatch
LDFLAGS		+= -e startup -T loader.lds -Ttext $(BIN_TEXT_START)

O_FORMAT 	= $(shell $(OBJDUMP) -i | head -2 | grep elf32)

OBJECTS		:= head.o loader.o cache.o board.o printf.o

ifneq ($(strip $(LOADER_DATA)),)
OBJECTS		+= data.o
CFLAGS		+= -DLOADADDR=$(LOADADDR)
endif


all: loader.elf

# Don't build dependencies, this may die if $(CC) isn't gcc
dep:

install:

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o : %.S
	$(CC) $(ASFLAGS) -c -o $@ $<

data.o: $(LOADER_DATA)
	$(LD) -r -b binary --oformat $(O_FORMAT) -T bin-data.lds -o $@ $<

loader: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

loader.bin: loader
	$(OBJCOPY) $(BIN_FLAGS) $< $@

loader2.o: loader.bin
	$(LD) -r -b binary --oformat $(O_FORMAT) -o $@ $<

loader.elf: loader2.o
	$(LD) -e startup -T loader2.lds -Ttext $(LOADADDR) -o $@ $<

mrproper: clean

clean:
	rm -f loader *.elf *.bin *.o
