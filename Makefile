USR=pancake@radare2
PUB=$(USR).pub
SEC=~/.signify/$(USR).secret
WWW=rada.re/get

# Release version
R2V=0.9.7
R2V=0.9.8
MSG=radare2-$(R2V).tar.xz
SIG=$(MSG).sig

all: $(PUB) $(SIG)

$(WWW)/$(MSG):
	wget -qc $(WWW)/$(MSG)
	signify -V -x $(SIG) -p $(PUB) -m $(MSG)

define getand =
	wget -O android-$(1)-$(2).tar.gz $(WWW)/pkg/android/$(1)/$(2)
endef

arm android-arm:
	$(call getand,arm,stable)
	$(call getand,arm,unstable)

aarch64 android-aarch64:
	$(call getand,aarch64,stable)
	$(call getand,aarch64,unstable)

mips android-mips:
	$(call getand,mips,stable)
	$(call getand,mips,unstable)

x86 android-x86:
	$(call getand,x86,stable)
	$(call getand,x86,unstable)

android: arm aarch64 mips x86

$(SIG):
	signify -S -x $(SIG) -s $(SEC) -m $(MSG)

$(PUB):
	mkdir -p ~/.signify/
	signify -G -p $(PUB) -s $(SEC) -c $(USR)

verify:
	signify -V -x $(SIG) -p $(PUB) -m $(MSG)

trust:
	mkdir -p git
	@for a in `cat TrustedGits` ; do \
		k=`echo $$a | cut -d = -f1` ; \
		v=`echo $$a | cut -d = -f2-` ; \
		if [ -d git/$$k ]; then \
			( cd git/$$k ; \
			git pull > /dev/null ) ; \
		else \
			git clone $$v git/$$k ; \
		fi ; \
		printf "$$k\t\t" ; \
		cmp git/$$k/$(SIG) $(SIG) ; \
		if [ $$? = 0 ]; then  \
			echo "Trusted" ; \
		else \
			echo "Untrusted" ; \
		fi ; \
	done

.PHONY: all trust
