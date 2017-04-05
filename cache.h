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
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 *
 */

#ifndef __CACHE_H
#define __CACHE_H

void flush_cache(unsigned long start_addr, unsigned long size);

#endif /* __CACHE_H */
