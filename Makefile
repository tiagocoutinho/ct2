### -*- mode: Makefile; coding: utf-8 -*- ###

#############################################################################
#                                                                           #
# Copyright © 2013-2014 Helmholtz-Zentrum Dresden Rossendorf                #
# Christian Böhme <c.boehme@hzdr.de>                                        #
#                                                                           #
# This program is free software: you can redistribute it and/or modify      #
# it under the terms of the GNU General Public License as published by      #
# the Free Software Foundation, either version 3 of the License, or         #
# (at your option) any later version.                                       #
#                                                                           #
# This program is distributed in the hope that it will be useful,           #
# but WITHOUT ANY WARRANTY; without even the implied warranty of            #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
# GNU General Public License for more details.                              #
#                                                                           #
# You should have received a copy of the GNU General Public License         #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.     #
#                                                                           #
#############################################################################

MAKE_CWD                    :=  $(shell pwd)

CT2_DRIVER_PATH             :=  driver
CT2_DRIVER_SRC_PATH         :=  $(CT2_DRIVER_PATH)/src

CT2_LIB_PATH                :=  lib
CT2_LIB_INC_PATH            :=  $(CT2_LIB_PATH)/include
CT2_LIB_SRC_PATH            :=  $(CT2_LIB_PATH)/src

CT2_TOOLS_PATH              :=  tools
CT2_BIN_PATH                :=  bin

ifndef KERNEL_SOURCES
ifndef TARGET_KERN
TARGET_KERN                 :=  $(shell uname -r)
endif
KERNEL_SOURCES              =   /lib/modules/$(TARGET_KERN)/build
endif

MAKE_CMD                    =   $(MAKE) -C $(KERNEL_SOURCES) M=$(MAKE_CWD)


all     :   kmod


init    :
	mkdir -p $(CT2_BIN_PATH)


kmod    : init c208_bit.c p201_bit.c
	$(MAKE_CMD) modules


clean   :
	$(MAKE_CMD) clean
	rm -f $(CT2_BIN_PATH)/*.o $(CT2_DRIVER_SRC_PATH)/*_bit.c 
	rm -f $(CT2_BIN_PATH)/bit2arr


%_bit.c :   $(CT2_TOOLS_PATH)/%.bit bit2arr
	$(CT2_BIN_PATH)/bit2arr $< $(CT2_DRIVER_SRC_PATH)/$@ > /dev/null


bit2arr:   $(CT2_TOOLS_PATH)/bit2arr.c
	$(CC) $(LDFLAGS) -o $(CT2_BIN_PATH)/$@ $^
