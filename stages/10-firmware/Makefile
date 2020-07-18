TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
FIRMWAREDIR	= $(BUILDDIR)/firmware
MODULESDIR	= $(BUILDDIR)/modules
BOOTTGZ		= $(BUILDDIR)/boot.tar.gz
MODULESTGZ	= $(BUILDDIR)/modules.tar.gz
VCTGZ		= $(BUILDDIR)/vc.tar.gz

TAR		= tar --owner 0 --group 0
SUDO		= sudo

FIRMWAREGITURL	= https://github.com/raspberrypi/firmware
FIRMWAREGITREF	= 1.20200601

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(BOOTTGZ) $(MODULESTGZ) $(VCTGZ)

upload:
	upload-artifacts.sh firmware $(BOOTTGZ) $(MODULESTGZ) $(VCTGZ)

$(BUILDDIR):
	mkdir -p $@

$(FIRMWAREDIR):
	git clone -b $(FIRMWAREGITREF) --depth 1 $(FIRMWAREGITURL) $@

$(MODULESTGZ): $(FIRMWAREDIR) $(BUILDDIR)
	mkdir -p $(MODULESDIR)/lib
	$(TAR) -C $(FIRMWAREDIR) -cf - modules | tar -C $(MODULESDIR)/lib -xf -
	$(TAR) -C $(MODULESDIR) -czf $@ .

$(BOOTTGZ): $(FIRMWAREDIR) $(BUILDDIR)
	$(TAR) -C $(FIRMWAREDIR)/boot -czf $@ .

$(VCTGZ): $(FIRMWAREDIR) $(BUILDDIR)
	$(TAR) -C $(FIRMWAREDIR)/hardfp -czf $@ opt/vc
