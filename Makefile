## brew innstall texinfo
# EMACS_VERSION=27.1
# RC_VERSION=
# PATCH_VERSION=8.0


.PHONY: all
.PHONY: build
.PHONY: clean
.PHONY: install
.PHONY: download
.PHONY: untar
.PHONY: args_check

all: args_check download untar build install

args_check:
ifndef EMACS_VERSION
	echo "変数 EMACS_VERSION を設定してください."
	exit 1
endif
ifndef PATCH_VERSION
	echo "変数 PATCH_VERSION を設定してください."
	exit 1
endif



download: args_check
	curl -O http://ftp.gnu.org/pub/gnu/emacs/emacs-$(EMACS_VERSION).tar.gz
	curl -O ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION).tar.gz

untar: download
	tar zxvf emacs-$(EMACS_VERSION).tar.gz
	tar zxvf emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION).tar.gz

build: untar
	cd emacs-$(EMACS_VERSION) && \
	patch -p 1 < ../emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION)/patch-mac && \
	cp -r ../emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION)/mac mac && \
	cp ../emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION)/src/* src && \
	cp ../emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION)/lisp/term/mac-win.el lisp/term && \
	cp nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns mac/Emacs.app/Contents/Resources/Emacs.icns && \
	./configure --with-mac --with-modules --without-x --with-mailutils
	$(MAKE) -C emacs-$(EMACS_VERSION) -j16 all

## https://masutaka.net/chalow/2014-10-25-1.html
## export CFLAGS+=`xml2-config --cflags`/libxml2
install: build
	sudo $(MAKE) -C emacs-$(EMACS_VERSION) install
	cp -r emacs-$(EMACS_VERSION)/mac/Emacs.app /Applications/Emacs-$(EMACS_VERSION)-mac-$(PATCH_VERSION).app


clean: args_check
	$(MAKE) -C emacs-$(EMACS_VERSION) clean
	@rm -rf *.tar.gz emacs-$(EMACS_VERSION) emacs-$(EMACS_VERSION)$(RC_VERSION)-mac-$(PATCH_VERSION)







