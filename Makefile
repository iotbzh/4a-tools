PREFIX=/usr/local

MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
MEDIA=$(wildcard $(MAKEFILE_DIR)/media/*)

all: help

help:
	@echo "Usage (root access required):"
	@echo "* make install"

install: $(MEDIA)
	@echo "Installing audio test files $(notdir $(MEDIA)) into $(DESTDIR)/media"
	mkdir -p $(DESTDIR)/media
	install $(MEDIA) -m 750 $(DESTDIR)/media

clean:
	@rm -vf $(SCRIPTS)
