SUITE		= buster
ARCH		= armhf
MIRRORURL	= $(RASPBIANREPOURL)
VARIANT		= minbase
INCLUDE		= dpkg
EXCLUDE		= nano
TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
SOURCESLIST	= $(BUILDDIR)/sources.list
APTLOCALCONF	= $(BUILDDIR)/aptlocal.conf
GNUPGDIR	= $(BUILDDIR)/gnupg
PUBKEY		= $(BUILDDIR)/key
ROOTFSDIR	= $(BUILDDIR)/rootfs
ROOTFSTGZ	= $(BUILDDIR)/rootfs.tar.gz

DEBOOTSTRAP	= qemu-debootstrap
SUDO		= sudo

RASPBIANREPOURL		= http://archive.raspbian.org/raspbian
RASPBIANKEYURL		= https://archive.raspbian.org/raspbian.public.key
RASPBERRYPIREPOURL	= http://archive.raspberrypi.org/debian
RASPBERRYPIKEYURL	= https://archive.raspberrypi.org/debian/raspberrypi.gpg.key

APTPROXY		?=

CI_REGISTRY		?=
CI_REGISTRY_USER	?=
CI_REGISTRY_PASSWORD	?=
CI_REGISTRY_IMAGE	?= embl0w-rpi

.PHONY: all clean build upload docker

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(ROOTFSTGZ)

upload:
	upload-artifacts.sh debootstrap $(ROOTFSTGZ)

docker:
	zcat $(ROOTFSTGZ) | docker import - rootfs-base
	docker tag rootfs-base $(CI_REGISTRY_IMAGE)/$(PRODUCT)/base
	docker build -t $(CI_REGISTRY_IMAGE)/$(PRODUCT)/build .
ifneq ($(CI_REGISTRY),)
	docker login -u $(CI_REGISTRY_USER) -p $(CI_REGISTRY_PASSWORD) $(CI_REGISTRY)
	docker push $(CI_REGISTRY_IMAGE)/$(PRODUCT)/base
	docker push $(CI_REGISTRY_IMAGE)/$(PRODUCT)/build
endif

$(BUILDDIR) $(ROOTFSDIR):
	mkdir -p $@

$(SOURCESLIST): $(BUILDDIR)
	echo "deb $(RASPBIANREPOURL) $(SUITE) main contrib non-free rpi" >>$@
	echo "deb $(RASPBERRYPIREPOURL) $(SUITE) main ui" >>$@

$(APTLOCALCONF): $(BUILDDIR)
	echo 'apt::install-recommends false;' >>$@
ifneq ($(APTPROXY),)
	echo 'acquire::http::proxy "$(APTPROXY)";' >>$@
endif

$(GNUPGDIR): $(BUILDDIR)
	export GNUPGHOME=$$(mktemp -d) && \
	curl -s $(RASPBIANKEYURL) | gpg --import && \
	mv $$GNUPGHOME $@

$(ROOTFSTGZ): $(ROOTFSDIR) $(SOURCESLIST) $(APTLOCALCONF) $(GNUPGDIR)
	$(SUDO) env http_proxy=$(APTPROXY) $(DEBOOTSTRAP) \
		--no-merged-usr \
		--arch $(ARCH) \
		--variant $(VARIANT) \
		--include $(INCLUDE) \
		--exclude $(EXCLUDE) \
		--keyring $(GNUPGDIR)/pubring.kbx \
		$(SUITE) $(ROOTFSDIR) $(MIRRORURL)
	$(SUDO) cp $(SOURCESLIST) $(ROOTFSDIR)/etc/apt/sources.list
	$(SUDO) cp $(APTLOCALCONF) $(ROOTFSDIR)/etc/apt/apt.conf.d
	curl -s $(RASPBERRYPIKEYURL) | $(SUDO) chroot $(ROOTFSDIR) apt-key add -
	$(SUDO) chroot $(ROOTFSDIR) apt-get update
	$(SUDO) rm -rf $(ROOTFSDIR)/var/lib/apt/* $(ROOTFSDIR)/var/cache/apt/*
	$(SUDO) tar --numeric-owner -C $(ROOTFSDIR) -czvf $@ .
