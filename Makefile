# making a new version:
#    change version number in this makefile
#    change version number near top of program
#    change version number in two places in /home/bcrowell/Documents/web/source/accelerando/index.source
#    make accelerando.1
#    make install
#    make post
#    touch /home/bcrowell/Documents/web/source/accelerando/index.source
#    cd /home/bcrowell/Documents/web/source && make && cd -
# Update it on freshmeat.

VERSION = 0.7
TARBALL = accelerando.tar.gz
DIST_DIR = accelerando-$(VERSION)

# for slug, where install doesn't exist:
INSTALL = cp
INSTALL_DIR = mkdir -p
BIN = /usr/bin
# for platforms where install exists:
#INSTALL = install
#INSTALL_DIR = install -d
# BIN = /usr/local/bin

prefix = /usr
MANDIR = $(prefix)/share/man/man1

install:
	$(INSTALL_DIR) /usr/share/apps/accelerando/sounds
	$(INSTALL) metronome_click.wav /usr/share/apps/accelerando/sounds
	$(INSTALL) metronome_click.mp3 /usr/share/apps/accelerando/sounds
	$(INSTALL) accelerando $(BIN)
	$(INSTALL) accelerando_helper $(BIN)
	chmod +rx $(BIN)/accelerando
	chmod +rx $(BIN)/accelerando_helper
	gzip -9 <accelerando.1 >accelerando.1.gz
	- test -d $(DESTDIR)$(MANDIR) || mkdir -p $(DESTDIR)$(MANDIR)
	$(INSTALL) accelerando.1.gz $(DESTDIR)$(MANDIR)
	chmod +r $(DESTDIR)$(MANDIR)/accelerando.1.gz
	rm -f accelerando.1.gz

dist: accelerando.1
	rm -f $(TARBALL)
	rm -Rf $(DIST_DIR)
	mkdir $(DIST_DIR)
	cp accelerando $(DIST_DIR)
	cp accelerando_helper $(DIST_DIR)
	cp metronome_click.wav $(DIST_DIR)
	cp metronome_click.mp3 $(DIST_DIR)
	cp Makefile $(DIST_DIR)
	cp make_plain_text_manpage.pl $(DIST_DIR)
	tar -zcvf $(TARBALL) $(DIST_DIR)
	rm $(DIST_DIR)/*
	rmdir $(DIST_DIR)

accelerando.1: accelerando
	pod2man --section=1 --center="accelerando $(VERSION)" --release="$(VERSION)" \
	        --name=accelerando <accelerando >accelerando.1

post:
	cp $(TARBALL) $(HOME)/Lightandmatter/accelerando
	make_plain_text_manpage.pl >$(HOME)/Documents/web/source/accelerando/manpage.txt
