# meta-xt-prod-devel

## Content
This document is long enough to have its own content. So below you will find:
* What is meta-xt-prod-devel
* Quickstart
* Usage and setup
  * Serial over USB
  * SSH over ethernet
  * What to do "on board"
* How to build
  * Preinstalled packets
  * Build script
  * Command-line options of `build_prod.py`
  * Build options
  * Few build hints
* How to install
  * Write to SD card
  * Write to eMMC
* Supported boards
* References

Important note.
All PC-related steps described below are intended to be run on Linux and were tested on Ubuntu 18.
Windows and MacOS are not supported, sorry.

## What is meta-xt-prod-devel

This is meta layer that allows you to run Linux+Linux or Linux+Android at the same time under Xen hypervisor on some Renesas' R-CAR boards.
List of fully or conditionally supported boards can be found at the end of this document.
Taking into account that you are interested in these sources, we suppose that you have some understanding of what is Xen hypervisor.
In case you need additional info look into the last section of this document - "References".
What prod-devel is?
* it is some reference implementation that demonstrates simultaneous run of few OS on the same hardware
Why it is under Xen hypervisor?
* it can reboot promptly in case of some failure met
* it can share hardware with some other special OS


## Quickstart

As far as meta-xt-prod-devel is meta-layer, it's not intended to be built by itself, but as part of a bigger system.
So, you need to use our tool to build the required system.
```
git clone git@github.com:xen-troops/build-scripts.git
cd build-scripts
python ./build_prod.py --machine h3ulcb-4x2g-kf --product devel \
    --config local-devel-u.cfg --with-local-conf --with-do-build
```
The build with DomU takes about six hours on iCore7 with 32GB and SSD. The build with DomA takes about eight hours on same PC.
You need to have 500GB of free space on disk mentioned in the  [path] section of local-devel-u.cfg.

Go to the `deploy` folder and run
```
./mk_sdcard_image.sh -p . -d ./image.img -c devel
```
You have an image that can be flashed to a microSD card using `dd`.
```
sudo dd if=./image.img of="your_sd_card_like_/dev/sdX" bs=1M status=progress
```
or bmaptool which is strongly recommended due to higher speed.
```
sudo bmaptool copy --bmap image.img.bmap ./imgage.img your_sd_card_like_/dev/sdX
```
But if you want to have the fastest speed of running - use internal eMMC of StarterKit.
This step is a little bit more complex than `dd` or `bmaptool` so you need to follow to section "How to install".

## Usage and setup
As far as it is reference implementation we will accent on the developer's usage. You can connect to the domain by:
1) serial over USB
2) SSH over ethernet

### Serial over USB
You need to connect your PC to the board by micro-USB cable.

Use your favorite serial console (`minicom`, `cu` etc).

Set port to 115200, 8N1, software flow control.

Connect your PC to the board's micro USB connector named "Debug serial". If needed - use detailed and labeled photo in wiki https://github.com/xen-troops/meta-xt-prod-devel/wiki

Turn on board and see messages are running.

### SSH over ethernet
At first, determine the IP that is assigned to the board.

If serial already works - you can login to DomD and check:
```
Dom0 login: root
# xl console DomD
domd login:root
# ifconfig
```
Or check your DHCP server. For example:
```
systemctl status isc-dhcp-server
```

Connect to board
```
ssh root@<board_ip>
```
After that, you will be logged straight into DomD.
Also, you can connect to DomU, just use port 23:
```
ssh -p 23 root@<board_ip>
```

### What to do "on board"
Use `root` to login to Dom0 or DomD (yes, it's just demo, and yes, we will close this security hole).

The main program inside Dom0 is `xl`. You can use
```
xl list                           - list running domains
xl console DomD                   - switch to DomD's console (press Ctrl-5 to return to Dom0)
xl destroy DomU                   - destroy DomU
xl create /xt/dom.cfg/domu.cfg -c - create DomU and switch to it's console
```
Detailed manual for `xl` you can find at https://xenbits.xen.org/docs/unstable/man/xl.1.html

The DomD contains quite regular Linux so you can use lots of regular Linux tools to do lots of regular Linux things.

Also, pay attention that DomD is home for backend drivers for guest domains like DomU or DomA. This means that DomU/DomA is working with real hardware using drivers in DomD. And if you stop network in DomD, DomU/DomA will be isolated from the world as well.

If you want to return to Dom0 - use `Ctrl-5`.


## How to build

### Preinstalled packets
When you build prod-devel, you build few operation systems with different settings and dependencies.
For this reason, we have quite a long list of required packets.
```
sudo apt install \
gawk wget diffstat texinfo chrpath socat libsdl1.2-dev checkpolicy bzr pigz  \
python-git python-github python-crypto python-ctypeslib python-clang-5.0     \
m4 lftp openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip    \
curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev   \
x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils \
xsltproc unzip gcc-5 g++-5 bc python3-pyelftools python3-pip python3-crypto  \
gcc-aarch64-linux-gnu \
-y

sudo pip3 install pycryptodomex
```
Download and install Google's repo tool: https://source.android.com/setup/develop#installing-repo

And make sure that you have two versions of python on your host PC
```
$ which python
/usr/bin/python
$ which python3
/usr/bin/python3
```


### Build script

Due to complex dependencies between different projects, you need to use a special python script to build a final product. The script will pull required layers and set configuration files.
So you need to get the script from GitHub and edit few lines in config.
Either clone repo
```
git clone https://github.com/xen-troops/build-scripts.git
```
or just download and unpack an archive
```
wget https://github.com/xen-troops/build-scripts/archive/master.zip
```
The folder contains two python files (the script itself), and configs for different products and specific cases.

Create `local-devel-u.cfg` with following content:
```
[git]
xt_history_uri = ""
xt_manifest_uri = git@github.com:xen-troops/meta-xt-products.git
[path]
workspace_base_dir = /<your_storage>/work_devel/build
workspace_storage_base_dir = /<your_storage>/storage
workspace_cache_base_dir = /<your_storage>/work_devel/tmp
[local_conf]
XT_GUESTS_INSTALL = "domu"
XT_GUESTS_BUILD = "domu"
```
Pay attention that you need to specify your own drive with about 500GB of free space.

Now you can run the script:
```
python ./build_prod.py --machine h3ulcb-4x2g-kf --product devel --config local-devel-u.cfg --with-local-conf --with-do-build
```

### Command-line options of `build_prod.py`
Use `-h` or `--help` to get help message.

Required arguments:

* `--machine` --- For possible values see first column in section "Supported boards".
* `--product` --- Two options are possible: `devel` or `devel-src`.

Optional arguments:

* `--with-local-conf` --- Generate `local.conf` for the build. Do not specify if you want to preserve existing `local.conf`.
* `--with-sdk` --- Populate SDK for the build.
* `--with-populate-cache` --- Populate build cache (sstate, ccache).
* `--with-do-build` --- Start build after initialization. If not specified, then script will fetch xt-distro, meta-xt-prod-devel, meta-xt-images, create local.conf and stop.
* `--with-build-history` --- Save build history in the git repository.
* `--continue-build` --- Continue existing build if any, do not clean up.
* `--retain-sstate` --- Do not remove SSTATE_DIR under any circumstances.
* `--parallel-build` --- Allow parallel building of domains.
* `--config` --- Use configuration file for tuning.
* `--branch` --- Use product's manifest from the branch specified. Useful if you want to build a specified release (`--branch REL-v7.0`).


### Build options
Here we will look into build options attentively.

#### XT_GUESTS_BUILD
Space-separated list of aliases of domains to build.

Aliases supported by prod-devel:

- `domu` for domu-image-weston (regular Linux as a guest)
- `doma` for domu-image-android (Android as a guest)

If the variable is empty or not defined then no guest domain will be built.

Pay attention that this variable affects but DomD also because different drivers and back-ends will be used for different guests.
```
XT_GUESTS_BUILD = "domu"
```

#### XT_GUESTS_INSTALL
Space-separated list of aliases of guest domains to be includes in the final image.

Aliases supported by prod-devel:

- `domu` for domu-image-weston (regular Linux as a guest)
- `doma` for domu-image-android (Android as a guest)

If you provide an empty string or do not define this variable that no guest domain will be included in the final build.
```
XT_GUESTS_INSTALL = "domu"
```

#### XT_RCAR_PROPRIETARY_MULTIMEDIA_DIR
Contains the path to the folder with proprietary multimedia packages for DomD. Evaluation multimedia packages can be downloaded from https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.1.0 (registration is required). You do not need to unpack all packages, just put files with names like `EVARTM0AC0000ADAACMZ1SL41C_3_0_12.zip`, and bitbake scripts will unpack needed files.

```
XT_RCAR_EVAPROPRIETARY_DIR = "/some_storage/prebuilt_binaries/mm/"
```

#### XT_RCAR_EVAPROPRIETARY_DIR
Contains the path to the folder with proprietary graphics packages for DomD and DomU. Usually it has name like `rcar-proprietary-graphic-<MACHINE_NAME>-xt-<DOMAIN>.tar.gz`, for example (Salvator-X board with H3 ES3.0, 8GB RAM):

 - rcar-proprietary-graphic-salvator-x-h3-4x2g-xt-domd.tar.gz
 - rcar-proprietary-graphic-salvator-x-h3-4x2g-xt-domu.tar.gz

You do not need to unpack these packages. Just put them into some folder and specify it (folder) in `XT_RCAR_EVAPROPRIETARY_DIR`.

```
XT_RCAR_EVAPROPRIETARY_DIR = "/some_storage/prebuilt_binaries/domd_domu/"
```

#### XT_ANDROID_PREBUILDS_DIR
Contains the path to the folder with proprietary graphics packages for DomA. Usually it has name like `rcar-prebuilts-<MACHINE_NAME>-xt-doma.tar.gz`, for example: `rcar-prebuilts-salvator-xs-h3-xt-doma.tar.gz`.

You need to unpack package into some folder /some_storage/prebuilt_binaries/doma and specify this folder in `XT_ANDROID_PREBUILDS_DIR`.

Following structure of folders is expected for DomA:
```
<XT_ANDROID_PREBUILDS_DIR>
├── pvr-km
│   └── pvrsrvkm.ko
└── pvr-um
    ├── prebuilds.mk
    └── vendor
        ├── bin
        ├── etc
        ├── lib
        └── lib64
```

If this variable is not specified you need to have access to proprietary graphic sources.

```
XT_ANDROID_PREBUILDS_DIR = "/some_storage/prebuilt_binaries/doma/"
```


#### XT_EXTERNAL_ANDROID_SOURCES
Android's sources are a huge thing with 130 GB that adds about a half-hour to fetching. And this variable allows to minimize android's impact on the build.
You can fetch android into a dedicated folder outside of yocto's build and just reuse it.

If this variable is defined then the build will not fetch android, and will not modify it, but will just run the build of it.

This gives you two important possibilities:

- allows you to keep your own changes to android's sources;
- significantly reduce build time if you do not erase the `out` folder inside android's sources after the first build. In this case, the build will just reuse already built android images.

```
XT_EXTERNAL_ANDROID_SOURCES = "/home/me/android_sources/"
```


#### XT_USE_VIS_SERVER
If have any value - VIS components will be used during the build.

See `AOS_VIS_PLUGINS` and `AOS_VIS_PACKAGE_DIR` for additional options.

If the variable is not defined or is empty - VIS will be not included in the build and `AOS_VIS_PLUGINS` and `AOS_VIS_PACKAGE_DIR` will be ignored.
```
XT_USE_VIS_SERVER = "true"
```

#### AOS_VIS_PLUGINS
Allows to specify VIS data provider and is used only if we build VIS using proprietary sources.

You can specify

"telemetryemulator" plugin that uses prerecorded data provided by telemetryemulator service launched in DomD

or

"renesassimulator" plugin that uses data provided by Renesas R-Car simulator.

Applicable only if `XT_USE_VIS_SERVER` is defined and `AOS_VIS_PACKAGE_DIR` is not defined.

If `XT_USE_VIS_SERVER` is defined and `AOS_VIS_PLUGINS` and `AOS_VIS_PACKAGE_DIR` are not defined,
then "renesassimulatoradapter" will be used as the default value.
```
AOS_VIS_PLUGINS = "renesassimulatoradapter"
```

#### AOS_VIS_PACKAGE_DIR
Specify folder containing prebuilt VIS binary.

Build system expects to find file `aos-vis` inside the specified folder. This file is renamed `aos-vis_git-r0_aarch64.ipk` that can be found in DomD's deploy directory.

So, you can put `aos-vis_git-r0_aarch64.ipk` into `AOS_VIS_PACKAGE_DIR` and rename it or create link to it using `ln -sfr aos-vis_git-r0_aarch64.ipk aos-vis`

Pay attention that `AOS_VIS_PACKAGE_DIR` has a higher priority than `AOS_VIS_PLUGINS`.

Applicable only if `XT_USE_VIS_SERVER` is defined.
```
AOS_VIS_PACKAGE_DIR = "/home/me/prebuilt_vis/"
```


### Few build hints
Pay attention that command with `--with-do-build` command will erase `workspace_base_dir` and start a clear build.

* In case of interruption you can just re-run the script keeping all fetched sources:
```
python ./build_prod.py --machine h3ulcb-4x2g-kf --product devel --config local-devel-u.cfg --continue-build
```

* You can get the "essence" of prod-aos, apply some patches/modifications and continue to build:
```
python ./build_prod.py --machine h3ulcb-4x2g-kf --product devel --config local-devel-u.cfg --with-local-conf
pushd <workspace_base_dir>/meta-xt-prod-devel
# do something, apply patches
popd
python ./build_prod.py --machine h3ulcb-4x2g-kf --product devel --config local-devel-u.cfg --continue-build
```

* To clear build products and intermediate files:
```
rm -rf <workspace_cache_base_dir>
cd <workspace_base_dir>/build
# remove everything except conf/ folder
rm -rf bitbake.lock buildhistory/ cache/ deploy/ log/ shared_rootfs/ tmp/
```

## How to install
You can run this product in few ways:

- from SD card
- from eMMC
- from network

### Write to SD card
As already mentioned in the Quickstart section, you can use `dd` or `bmaptool`.
```
sudo dd if=./image.img of="/dev/sd_X_" bs=1M status=progress
```
or `bmaptool` which is strongly recommended due to lower time spent for flashing (up to x2 depending on binary image).
```
sudo bmaptool copy --bmap image.img.bmap ./imgage.img /dev/sd_X_
```

### Write to eMMC
We have two ways to put binaries onto eMMC: using an SD card or using TFTP with NFS.

#### Write to eMMC using SD card
You can write it "by hands" or "by script". Both ways are described on the following page
https://github.com/xen-troops/meta-xt-prod-devel/wiki/How-to-flash-image-to-eMMC-from-SD-card

#### Write to eMMC using network
Please follow instruction to set up NFS and TFTP servers on local hostm, and to boot board
https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.1.0#Loading_kernel_via_TFTP_and_rootfs_via_NFS

Place image of product into root folder of your NFS server.

Connect to board by minicom. See chapter "Serial over USB" for some details.

You should see Dom0's login prompt `generic-armv8-xt-dom0 login:`.

Log in as `root`.

Check that image file is accessible:
```
ls -l /image.img
```

Flash image file into eMMC:
```
dd if=/image.img of=/dev/mmcblk0 bs=1M status=progress
```

Reboot board
```
reboot
```

## Supported boards
In general, we support boards with H3 ES3.0 and M3 with 8GB. To be more specific:

MACHINE_NAME        | Board name        | SoC      | RAM
--------------------|-------------------|----------|----
salvator-x-h3-4x2g  | Salvator-X        | H3 ES3.0 | 8GB
salvator-xs-m3-2x4g | Salvator-XS       | M3 ES3.0 | 8GB
salvator-xs-h3-4x2g | Salvator-XS       | H3 ES3.0 | 8GB
h3ulcb-4x2g         | H3ULCB            | H3 ES3.0 | 8GB
h3ulcb-4x2g-kf      | H3ULCB KingFisher | H3 ES3.0 | 8GB


## References
* If you are not aware of what is meta-layer - you may read Yocto's documentation at https://www.yoctoproject.org/docs/
* If you want to understand what is a hypervisor and guest OS - check https://xenproject.org/help/documentation/
* To review Renesas boards - check https://www.renesas.com/eu/en/solutions/automotive/adas/solution-kits/r-car-starter-kit.html
* Wiki of prod-devel https://github.com/xen-troops/meta-xt-prod-devel/wiki
