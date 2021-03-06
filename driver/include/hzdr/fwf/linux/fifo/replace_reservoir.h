/* -*- mode: C; coding: utf-8 -*- */

/****************************************************************************
 *                                                                          *
 * Copyright © 2014 Helmholtz-Zentrum Dresden Rossendorf                    *
 * Christian Böhme <c.boehme@hzdr.de>                                       *
 *                                                                          *
 * This program is free software: you can redistribute it and/or modify     *
 * it under the terms of the GNU General Public License as published by     *
 * the Free Software Foundation, either version 3 of the License, or        *
 * (at your option) any later version.                                      *
 *                                                                          *
 * This program is distributed in the hope that it will be useful,          *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
 * GNU General Public License for more details.                             *
 *                                                                          *
 * You should have received a copy of the GNU General Public License        *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.    *
 *                                                                          *
 ****************************************************************************/

//  HZDR_FWFI_LINUX_FIFO_REPLACE_RESERVOIR_H

#include <linux/kernel.h>               // container_of()


/**
 * fifo_replace_reservoir - replace the current entry reservoir of a FIFO
 * @fifo:       FIFO whose entry reservoir to replace
 * @new_fbh:    pointer to the "write end FESU" of @fifo's new entry reservoir
 *
 * returns: pointer to the "write end FESU" of @fifo's current entry reservoir or
 *          "NULL" if @fifo had no entry reservoir
 */

static inline
struct HFL_FIFO_IDENT(fifo_bhead) *
HFL_FIFO_IDENT(fifo_replace_reservoir)( struct HFL_FIFO_IDENT(fifo) * fifo,
                                        struct HFL_FIFO_IDENT(fifo_bhead) * new_fbh )
{
    struct HFL_FIFO_IDENT(fifo_bhead) * fbh = container_of(fifo->w.ea_ptr, struct HFL_FIFO_IDENT(fifo_bhead), ea[0]);


    fifo->capacity = new_fbh->max_index + 1;
    fifo->fillpoint = 0;
    fifo->w.ea_ptr = &(new_fbh->ea[0]);
    fifo->w.off = 0;
    fifo->r = fifo->w;

    return fbh;
}

//  HZDR_FWFI_LINUX_FIFO_REPLACE_RESERVOIR_H
