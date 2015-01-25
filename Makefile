USR=pancake@radare2
PUB=$(USR).pub
SEC=~/.signify/$(USR).secret
WWW=rada.re/get
WGET?=wget
SIGNIFY=signify

# Release version
R2V=0.9.7
R2V=0.9.8
R2V_W32=0.9.8.git
R2V_OSX=0.9.8

FILE=radare2-$(R2V).tar.xz
SIG=$(FILE).sig

all: $(PUB) $(SIG)
	@echo "Usage: make [get|sign|verify|trust] FILE=<radare2-0.9.8.tar.gz>"
	@echo 'Also see: `get-all`, `trust-all`, `verify-all` and `sign-all` targets'

include targets.mk

signify:
	git clone https://github.com/aperezdc/signify.git
	cd signify ; $(MAKE)

install-signify signify-install:
	cp -f signify/signify /usr/bin

$(WWW)/$(FILE):
	$(WGET) -qc $(WWW)/$(FILE)
	$(SIGNIFY) -V -x $(SIG) -p $(PUB) -m $(FILE)

get:
	@$(MAKE) $(FILE)

get-all:
	for a in $(FILES) ; do $(MAKE) $$a ; done

$(SIG):
	$(SIGNIFY) -S -x $(SIG) -s $(SEC) -m $(FILE)

$(PUB):
	@mkdir -p ~/.signify/
	$(SIGNIFY) -G -p $(PUB) -s $(SEC) -c $(USR)

verify:
	@printf "$(FILE)\t"
	$(SIGNIFY) -V -x $(SIG) -p $(PUB) -m $(FILE)

verify-all:
	@for a in *.sig ; do $(MAKE) -s verify FILE=`echo $$a | sed -e s,.sig,,` || exit 1 ; done

sign:
	@printf "$(FILE)\t"
	[ ! -f $(FILE) ] && $(MAKE) $(FILE) || true
	$(SIGNIFY) -S -x $(SIG) -s $(SEC) -m $(FILE)

sign-all:
	@for a in *.sig ; do $(MAKE) -s sign FILE=`echo $$a | sed -e s,.sig,,` || exit 1 ; done

trust:
	@mkdir -p git
	@for a in `cat TrustedGits` ; do \
		k=`echo $$a | cut -d = -f1` ; \
		v=`echo $$a | cut -d = -f2-` ; \
		if [ -d git/$$k ]; then \
			( cd git/$$k ; \
			git pull > /dev/null ) ; \
		else \
			git clone $$v git/$$k ; \
		fi ; \
		printf "$$FILE\t$$k\t\t" ; \
		cmp git/$$k/$(SIG) $(SIG) 2> /dev/null ; \
		if [ $$? = 0 ]; then  \
			printf "\033[32mTrusted\033[0m\\n" ; \
		else \
			printf "\033[31mUntrusted\033[0m\\n" ; \
		fi ; \
	done

trust-all:
	@for a in *.sig ; do $(MAKE) -s trust FILE=`echo $$a | sed -e s,.sig,,` || exit 1 ; done

.PHONY: get trust sign sign-all verify verify-all arm mips x86 aarch64
