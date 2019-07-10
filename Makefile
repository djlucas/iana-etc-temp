# Copyright (c) 2003-2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 3.0
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-3.0.txt

# Makefile: See README for usage

DESTDIR=
PREFIX=
ETC_DIR=/etc

AWK=gawk
PERL=perl

.PHONY: all files get test test-services test-protocols install clean \
	protocol-numbers.xml service-names-port-numbers.xml dist

all: files
files: protocols services

get: protocol-numbers.xml service-names-port-numbers.xml

test: test-protocols test-services

test-services: services
	$(AWK) --re-interval -f test-lib.gawk -f test-services.gawk <services

test-protocols: protocols
	$(AWK) -f test-lib.gawk -f test-protocols.gawk <protocols

install: files
	install -d $(DESTDIR)$(PREFIX)$(ETC_DIR)
	install -m 644 protocols $(DESTDIR)$(PREFIX)$(ETC_DIR)
	install -m 644 services $(DESTDIR)$(PREFIX)$(ETC_DIR)

clean:
	rm -vf \
	    protocols services \
	    protocol-numbers service-names-port-numbers \
	    protocol-numbers.xml service-names-port-numbers.xml

protocol-numbers.xml:
	$(PERL) get.pl protocol-numbers

service-names-port-numbers.xml:
	$(PERL) get.pl service-names-port-numbers

protocol-numbers:
ifeq (protocol-numbers.xml, $(wildcard protocol-numbers.xml))
	ln -f -s protocol-numbers.xml protocol-numbers
else
	ln -f -s protocol-numbers.dist protocol-numbers
endif

servicee-names-port-numbers:
ifeq (service-names-port-numbers.xml, $(wildcard service-names-port-numbers.xml))
	ln -f -s service-names-port-numbers.xml service-names-port-numbers
else
	ln -f -s service-names-port-numbers.dist service-names-port-numbers
endif

protocols: protocol-numbers protocols.gawk
	$(AWK) -f protocols.gawk -F"[<>]" protocol-numbers > protocols

services: service-names-port-numbers services.gawk
	$(AWK) -f services.gawk -F"[<>]" service-names-port-numbers > services

dist: clean
	rm -vrf iana-etc-`cat VERSION`
	cp -a . iana-etc-`cat VERSION` || true
	tar --owner=root --group=root  -vJcf iana-etc-`cat VERSION`.tar.xz \
	    iana-etc-`cat VERSION`
	mv iana-etc-`cat VERSION`.tar.xz ..
	rm -rf iana-etc-`cat VERSION`

