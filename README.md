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
After a successful build, images can be found in 
output/xilinx-zc702-2020.2/images/linux/

# Todo
1. UART
2. SPI
3. USB

