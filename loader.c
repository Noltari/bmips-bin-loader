/*
 * Binary loader for BMIPS CFE based boards
 * Copyright (C) 2017 Álvaro Fernández Rojas <noltari@gmail.com>
 *
 * Some parts of this file was based on the LZMA compressed kernel loader
 * for Broadcom BMIPS based boards:
 *	Copyright (C) 2014 Jonas Gorski <jogo@openwrt.org>
 *
 * Some parts of this file was based on the LZMA compressed kernel loader
 * for Atheros AR7XXX/AR9XXX based boards:
 *	Copyright (C) 2011 Gabor Juhos <juhosg@openwrt.org>
 *
 * Some parts of this code was based on the OpenWrt specific lzma-loader
 * for the BCM47xx and ADM5120 based boards:
 *	Copyright (C) 2004 Manuel Novoa III (mjn3@codepoet.org)
 *	Copyright (C) 2005 Mineharu Takahara <mtakahar@yahoo.com>
 *	Copyright (C) 2005 by Oleg I. Vdovikin <oleg@cs.msu.su>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <stddef.h>
#include <stdint.h>

#include "cache.h"
#include "printf.h"

/* beyond the image end, size not known in advance */
extern unsigned char workspace[];

extern void board_init(void);

static unsigned char *bin_data;
static unsigned long bin_datasize;
static unsigned long bin_loadaddr;

static void copy_data(unsigned char *outStream)
{
	unsigned long curPos;

	for (curPos = 0; curPos < bin_datasize; curPos++)
		outStream[curPos] = bin_data[curPos];
}

static void init_data(void)
{
	extern unsigned char _bin_data_start[];
	extern unsigned char _bin_data_end[];

	bin_loadaddr = LOADADDR;
	bin_data = _bin_data_start;
	bin_datasize = _bin_data_end - _bin_data_start;
}

void loader_main(unsigned long reg_a0, unsigned long reg_a1,
		 unsigned long reg_a2, unsigned long reg_a3)
{
	void (*bin_entry)(void);

	board_init();

	printf("\n\nBinary loader for BMIPS CFE\n");
	printf("Copyright (C) 2011 Gabor Juhos <juhosg@openwrt.org>\n");
	printf("Copyright (C) 2014 Jonas Gorski <jogo@openwrt.org>\n");
	printf("Copyright (C) 2017 Álvaro Fernández Rojas <noltari@gmail.com>\n");

	init_data();

	printf("Copying data... ");
	copy_data((unsigned char *) bin_loadaddr);
	printf("done!\n");

	flush_cache(bin_loadaddr, bin_datasize);

	printf("Starting kernel at %08x...\n\n", bin_loadaddr);

	bin_entry = (void *) bin_loadaddr;
	bin_entry();
}
