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

## Store artifacts in cloud storage using rclone

It can utilize [rclone](https://rclone.org/) to integrate various cloud storage services
such as AWS S3, Azure Blob, Google Cloud Storage.
It uses `artifacts:` remote to upload/download artifacts at each stage.
You can configure it with [environment variables](https://rclone.org/docs/#environment-variables).

Example for Azure Blob Storage (https://embl0wartifacts.blob.core.windows.net/foobar/...):
```sh
export RCLONE_CONFIG_ARTIFACTS_TYPE=alias
export RCLONE_CONFIG_ARTIFACTS_REMOTE=azureblob:foobar
export RCLONE_CONFIG_AZUREBLOB_TYPE=azureblob
export RCLONE_CONFIG_AZUREBLOB_ACCOUNT=embl0wartifacts
export RCLONE_CONFIG_AZUREBLOB_KEY=XXXXXXXX
```

Example for AWS S3 (https://embl0wartifacts.s3-ap-northeast-1.amazonaws.com/foobar/...):
```sh
export RCLONE_CONFIG_ARTIFACTS_TYPE=alias
export RCLONE_CONFIG_ARTIFACTS_REMOTE=s3:embl0wartifacts/foobar
export RCLONE_CONFIG_S3_TYPE=s3
export RCLONE_CONFIG_S3_REGION=ap-northeast-1
export RCLONE_CONFIG_S3_SECRET_ACCESS_KEY_ID=XXXXXXXX
export RCLONE_CONFIG_S3_SECRET_ACCESS_KEY=XXXXXXXX
```

To enable rclone, you must run `make build` with `ARTIFACTSDIR=`.

```console
$ time sudo make build ARTIFACTSDIR=
```
