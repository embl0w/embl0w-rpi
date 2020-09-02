TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
PREBUILTDIR	= $(BUILDDIR)/prebuilt
BOOTFSDIR	= $(BUILDDIR)/bootfs
BOOTIMG		= $(BUILDDIR)/boot.img
BOOTIMGGZ	= $(BOOTIMG).gz

SUDO		= sudo

BOOTIMAGESIZE	= 1024
BOOTPARTSIZE	= 512

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(BOOTIMGGZ)

upload:
	upload-artifacts.sh image $(BOOTIMGGZ)

$(PREBUILTDIR):
	download-artifacts.sh boot $(PREBUILTDIR)

$(BOOTFSDIR): $(PREBUILTDIR)
	mkdir -p $@
	tar -C $@ -xzf $(PREBUILTDIR)/boot/bootfs.tar.gz

$(BOOTIMG): $(BOOTFSDIR)
	./scripts/makeimage.sh $@ $(BOOTIMAGESIZE) $(BOOTPARTSIZE)
	mcopy -i $@@@1M $(BOOTFSDIR)/* ::

$(BOOTIMGGZ): $(BOOTIMG)
	gzip -c9 $(BOOTIMG) >$@
