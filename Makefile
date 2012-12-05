#
# Copyright (C) 2010-2011 ARM Limited. All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

UMP_DIR ?= .
UMP_LIB ?= libUMP
UDD_OS ?= linux
TARGET_CC ?= $(CROSS_COMPILE)gcc
TARGET_AR ?= $(CROSS_COMPILE)ar
INSTALL = install -m 644
includedir ?= /usr/include
libdir ?= /usr/lib
CFLAGS += -I$(UMP_DIR)/include -I$(UMP_DIR)/include/ump -Wall -march=armv7-a -mthumb-interwork -fno-strict-aliasing -fPIC -Wno-strict-aliasing -Wno-long-long -O3
LDFLAGS += -Wl,--no-as-needed -ldri2 -ldrm -lXfixes
include ump.mak

%.o: %.c
	$(TARGET_CC) -c -o $@ $< $(CFLAGS)

UMP_OBJS := $(UMP_SRCS:.c=.o)

libUMP.so: $(UMP_OBJS)
	$(TARGET_CC) -shared -o $@ $(UMP_OBJS) $(CFLAGS) $(LDFLAGS)
libUMP.a: $(UMP_OBJS)
	$(TARGET_AR) rcs $@ $(UMP_OBJS)

install: all
	$(INSTALL) libUMP.so $(libdir)/libUMP.so
	mkdir $(includedir)/ump
	$(INSTALL) include/ump/ump.h $(includedir)/ump/ump.h
	$(INSTALL) include/ump/ump_platform.h  $(includedir)/ump/ump_platform.h	
	$(INSTALL) include/ump/ump_debug.h  $(includedir)/ump/ump_debug.h
	$(INSTALL) include/ump/ump_osu.h  $(includedir)/ump/ump_osu.h
	$(INSTALL) include/ump/ump_ref_drv.h  $(includedir)/ump/ump_ref_drv.h
	$(INSTALL) include/ump/ump_uk_types.h  $(includedir)/ump/ump_uk_types.h

.DEFAULT_GOAL = all
all: libUMP.so libUMP.a

clean:
	-rm -f $(UMP_OBJS) libUMP.so libUMP.a

.PHONY: all clean install
