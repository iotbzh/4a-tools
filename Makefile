DESTDIR?=/usr/local

MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

SCRIPTS=$(wildcard $(MAKEFILE_DIR)/bin/*)
MEDIA=$(wildcard $(MAKEFILE_DIR)/media/*)

all: help

help:
	@echo "Usage (root access required):"
	@echo "* make install"
	@echo "  will install scripts in $(DESTDIR)" 
	@echo "* make install DESTDIR=/usr"
	@echo "  changes the destination dir (in this example, the scripts will be installed in /usr/bin)"

install: $(SCRIPTS) $(MEDIA)
	@echo "Installing audio scripts $(notdir $(SCRIPTS)) into $(DESTDIR)/bin"
	mkdir -p $(DESTDIR)/bin 
	install $(SCRIPTS) -m 750 $(DESTDIR)/bin
	@echo "Installing audio test files $(notdir $(MEDIA)) into $(DESTDIR)/4a/media"
	mkdir -p $(DESTDIR)/4a/media
	install $(MEDIA) -m 640 $(DESTDIR)/4a/media

clean:
	@echo "Cleanup done."
