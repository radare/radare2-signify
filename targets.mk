# Android
define getand =
	wget -O android-$(1)-$(2).tar.gz $(WWW)/pkg/android/$(1)/$(2)
endef

FILES+=android-arm-stable.tar.gz
FILES+=android-arm-unstable.tar.gz
FILES+=android-aarch64-stable.tar.gz
FILES+=android-aarch64-unstable.tar.gz
FILES+=android-mips-stable.tar.gz
FILES+=android-mips-unstable.tar.gz
FILES+=android-x86-stable.tar.gz
FILES+=android-x86-unstable.tar.gz
FILES+=radare2-$(R2V).tar.xz
FILES+=radare2-$(R2V_OSX).pkg
FILES+=radare2-w32-$(R2V_W32).zip

android-arm-stable.tar.gz:
	$(call getand,arm,stable)

android-arm-unstable.tar.gz:
	$(call getand,arm,unstable)

android-aarch64-stable.tar.gz:
	$(call getand,aarch64,stable)

android-aarch64-unstable.tar.gz:
	$(call getand,aarch64,unstable)

android-mips-stable.tar.gz:
	$(call getand,mips,stable)

android-mips-unstable.tar.gz:
	$(call getand,mips,unstable)

android-x86-stable.tar.gz:
	$(call getand,x86,stable)

android-x86-unstable.tar.gz:
	$(call getand,x86,unstable)

arm android-arm:
	$(MAKE) android-arm-stable.tar.gz
	$(MAKE) android-arm-unstable.tar.gz

aarch64 android-aarch64:
	$(MAKE) android-aarch64-stable.tar.gz
	$(MAKE) android-aarch64-unstable.tar.gz

mips android-mips:
	$(MAKE) android-mips-stable.tar.gz
	$(MAKE) android-mips-unstable.tar.gz

x86 android-x86:
	$(MAKE) android-x86-stable.tar.gz
	$(MAKE) android-x86-unstable.tar.gz

# Source
radare2-$(R2V).tar.xz:
	$(WGET) -c $(WWW)/radare2-$(R2V).tar.xz

# W32
radare2-w32-$(R2V_W32).zip:
	$(WGET) -c $(WWW)/pkg/radare2-w32-$(R2V_W32).zip

w32: radare2-w32-$(R2V_W32).zip
	@$(MAKE) verify FILE=radare2-w32-$(R2V_W32).zip

# OSX
radare2-$(R2V_OSX).pkg:
	$(WGET) -c $(WWW)/pkg/radare2-$(R2V_OSX).pkg

osx: radare2-$(R2V_OSX).pkg
	@$(MAKE) verify FILE=radare2-$(R2V_OSX).pkg

android: arm aarch64 mips x86
