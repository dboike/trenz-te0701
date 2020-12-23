# trenz-te0701
BSP for Trenz TE701-06

# Building
## Dependencies

The following dependencies must be downloaded from xilinx using your xililinx
account.  At this time, there is not charge for creating an account.  The files
must be stored in a local directory.  The "Configuration" section of 
Makefile must match your download specifications.  This can be accomplished
with environment variables or by modifying the "Configuration" section of
Makefile.

* Petalinux is downloaded from https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2020.2-final-installer.run
* Petalinux BSP is downloaded from https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zc702-v2020.2-final.bsp

## Build Command
2. To create the foundation image from Petalinux and the BSP, issue the following command from this directory:

```bash
make build_bsp
```
## Images
Prebuilt images are available in the repo.  It is not necessary to download and compile Petalinux system.  Two Makefile targets are provided.  The work flow is to insert a removable SD card in a Linux system then run "make image" or one of the make image variants.  Examples as follows
### Latest Test Image
The 'Test Image' is the latest build of the complete system.  After successful testing on hardware, the test image will be tagged and promoted to a release build. The test image can be written to a SD card as follows:
```bash
git clone https://github.com/dboike/trenz-te0701
cd trenz-te0701/
# SD card is inserted and appears on my system as /dev/sdd
make image IMAGE_DEV=sdd
```
### Reference Image
The PetaLinux reference design image is provided in the images archive.  The purpose of this image is to provide a reference point for a known good image.  This image is provided by the Petalinux SDK / BSP.  It is not recompiled. The reference image can be written to a SD card as follows:
```bash
git clone https://github.com/dboike/trenz-te0701
cd trenz-te0701/
# SD card is inserted and appears on my system as /dev/sdd
make image-prebuilt IMAGE_DEV=sdd
```

# Todo
1. UART
2. SPI
3. USB

