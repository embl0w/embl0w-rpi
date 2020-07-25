# embl0w-rpi

Yet another embedded Linux project for Raspberry Pi.
It's based on Raspberry Pi OS (formerly Raspbian) / Debian.

## Usage

Build host prerequisites: Ubuntu or Debian based Linux with 5GB free disk space.

If the host architecture is other than ARM,
you will need binfmt_misc privilege or preconfigured environment
to run qemu-debootstrap for ARM Linux environment.

Set up the build evironment:

```console
$ sudo make setup
```

Build the boot disk image in the artifacts/image folder:

```console
$ sudo make clean
$ time sudo make build
```

Write the image into a MicroSD device (make sure replacing `/dev/sdb` with your actual device)

```console
$ zcat artifacts/image/boot.img.gz | sudo dd of=/dev/sdb bs=1M
```
