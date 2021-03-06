# Altho it is totally possible to strip most of this Makefile and leave only the
# `spid` rule, along with the `all` rule (dependent on the former one), I prefer
# to have an explicit `spid.exe` rule producing the `.exe` binary on windows, in
# case the compiler doesn't automatically produce `.exe` files out of extension-
# less names passed to the output flag.

ifeq ($(OS),Windows_NT)
    DEFAULT_BIN = spid.exe
    CCFLAGS += -D WIN32
    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
        CCFLAGS += -D AMD64
    endif
    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
        CCFLAGS += -D IA32
    endif
else
    DEFAULT_BIN = spid
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        CCFLAGS += -D LINUX
    endif
    ifeq ($(UNAME_S),Darwin)
        CCFLAGS += -D OSX
    endif
    UNAME_P := $(shell uname -p)
    ifeq ($(UNAME_P),x86_64)
        CCFLAGS += -D AMD64
    endif
    ifneq ($(filter %86,$(UNAME_P)),)
        CCFLAGS += -D IA32
    endif
    ifneq ($(filter arm%,$(UNAME_P)),)
        CCFLAGS += -D ARM
    endif
endif

all: $(DEFAULT_BIN)
	@echo "All done. Quitting"

spid: spid.c
	$(CC) -o $@ $<

spid.exe: spid.c
	$(CC) -o $@ $<

clean:
	rm -rf *.o spid spid.exe

.PHONY: all clean
