HB_CLIENT = hb_client

####### x86 mips463 mips342 ######
PLATFORM := mips342

DEBUG_CMP := y
#DEBUG_LIB :=
ENCRY := DES
CVNWARE := 
MTK := y

##########################  platform for x86 #######################
ifeq ($(PLATFORM),x86)
CC = gcc
STRIP = strip
LIBS += -L. -L/usr/lib64
endif

##########################  platform for mips463 #######################
ifeq ($(PLATFORM),mips463)
CC = /opt/buildroot-gcc463/usr/bin/mipsel-buildroot-linux-uclibc-gcc
STRIP = /opt/buildroot-gcc463/usr/bin/mipsel-buildroot-linux-uclibc-strip
LIBS +=-L. -L/opt/buildroot-gcc463/usr/mipsel-buildroot-linux-uclibc/sysroot/lib/
endif

##########################  platform for mips342 #######################
ifeq ($(PLATFORM),mips342)
CC = /opt/buildroot-gcc342/bin/mipsel-linux-gcc
STRIP = /opt/buildroot-gcc342/bin/mipsel-linux-strip
LIBS +=-L. -L/opt/buildroot-gcc342/lib/
endif


##########################  common for all #######################
LDFLAGS +=
CFLAGS += -I. 
ifeq ($(DEBUG_CMP),y)
CFLAGS += -g -rdynamic 
endif

CCOMPILE = $(CC) $(LDFLAGS) $(CFLAGS) -c  
LIBEX += -lpthread
LIBA =

BINDIR := ./

############################# register for cvnware ###############
ifeq ($(CVNWARE),y)
CFLAGS += -I$(TOPDIR)/include -I$(TOPDIR)/uim/webs-2-5
CFLAGS += -DCVNWARE
TOPDIR := ../../..
#include $(TOPDIR)/.config
#include $(TOPDIR)/rules/libm.mk
ROMFSDIR :=../../../../sdk/RT288x_SDK/source/romfs
BINDIR := $(TOPDIR)/bin
endif

############################# register for MTK ###############
ifeq ($(MTK),y)
CFLAGS += -DMTK
LIBEX += -lnvram-0.9.28
endif

HB_CLIENT_SRC := hb_client.c hb_core.c debug.c profile.c XORcode.c net.c

ifeq ($(ENCRY),DES)
HB_CLIENT_SRC += des.c deskey.c
CFLAGS += -DCRYTO_DES
endif

#ifdef DEBUG_LIB
#HB_CLIENT_SRC += debug.c
#AUTH_CORE_SRC += debug.c
#CFLAGS += -DDEBUG_LIB
#endif

all:$(HB_CLIENT)
	$(STRIP) $(HB_CLIENT)
	#cp -f hb_client $(BINDIR)

$(HB_CLIENT):  
	$(CC) -o $@ $(HB_CLIENT_SRC) $(CFLAGS) $(LDFLAGS) $(LIBS) $(LIBEX)

$(AUTH_CLI):  
	$(CC) -o $@ auth_cli.c $(CFLAGS) $(LIBS) $(LIBEX)	
	
$(AUTH_CORE):
	$(CC) -o libauth_core.so $(AUTH_CORE_SRC) -fPIC -shared $(CFLAGS) $(LDFLAGS)
	

IPC_CLIENT_LIBEX = -lauth_core -lpthread
$(IPC_CLIENT):
	$(CC) -o $@ unix_ipc_client.c $(LIBS) $(IPC_CLIENT_LIBEX)	

$(AUTH_MARKET):
	$(CC) -o $@ auth_market.c $(CFLAGS) $(LIBS) $(LIBEX)

	
.PHONY: clean backup $(HB_CLIENT)
clean: 
	rm -f $(HB_CLIENT) *.o

HFILE := cJSON.h debug.h dms_dev.h dms_zigbee.h InnerClient.h list.h utils.h wireless.h
backup:
	rm backup -rf
	mkdir backup
	cp $(CSRCS) $(CXXSRCS) $(HFILE) Makefile backup
