USR=pancake@radare2
PUB=$(USR).pub
SEC=~/.signify/$(USR).secret
WWW=rada.re/get

R2V=0.9.7
R2V=0.9.8
MSG=radare2-$(R2V).tar.xz
SIG=$(MSG).sig

all: $(PUB) $(SIG)
	wget -qc $(WWW)/$(MSG)
	signify -V -x $(SIG) -p $(PUB) -m $(MSG)

$(SIG):
	signify -S -x $(SIG) -s $(SEC) -m $(MSG)

$(PUB):
	mkdir -p ~/.signify/
	signify -G -p $(PUB) -s $(SEC) -c $(USR)

trust:
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
