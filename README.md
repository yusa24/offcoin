=======
offcoin
=======

setup offline ubuntu with armory on mac osx

## TODO

* For all file copies/installations, check if it exists and rm if it does, then install fresh (prevent old files hanging around)

* Test armory/truecrypt installation on ubuntu

* DO NOT skip if a file exists, unless there is good reason, overwrite it!!

* chmod +x ./offcoin-offline.sh && ./offcoin-offline.sh

* Clearly state analytics are recorded via utils/parse.sh, run offcoin-notrack.sh to avoid analytic tracking

* Prompt for attached drives to select for setup-ubuntu.sh

* Copy offcoin to FREE space on setup bootable flash drive

* TODO: copy tools (e.g. vanitygen, bitaddress, etc.) here for user
* TODO: symlink shortcut to ~/bitcoin on desktop
* https://en.bitcoin.it/wiki/Vanitygen


## Install

* 3 options (easiest <-> hardest)
* Single line, setup thumb drive and copy offcoin to FREE space on bootable drive
* Single line, copy offcoin to external drive to run on offline ubuntu
* Download tarball, run locally or copy to external drive to run on offline ubuntu

create and boot into usb flash drive (mac)
windows just use universal usb installer
insert flash drive
diskutil list
	figure out which /dev/disk# is flash drive
	use user prompt to get drive number
diskutil unmountDisk /dev/disk#
sudo fdisk -e /dev/rdisk#s1
use here doc

sudo fdisk -e /dev/rdisk#s1 <<EOF
f 1
write
exit
EOF


or pipe in interactive commands
echo “f 1
write
exit” | sudo fdisk -e /dev/rdisk#s1

be sure disk is not mounted
diskutil unmountDisk /dev/disk#

write syslinux mbr.bin onto flash drive
sudo dd conv=notrunc bs=440 count=1 if=syslinux/bios/mbr/mbr.bin of=/dev/disk#

be sure disk is not mounted
diskutil unmountDisk /dev/disk#

unetbootin
select the diskimage radio button and provide the path to the iso file
enter space to be preserved, by default the maximum for this space is 4gb although it can be extended, for our purposes this is just fine, so enter 4096 (4gb)
select the usb drive and first partitions drive, i.e. /dev/disk#s1

wait.

modify /volumes/<usbdrivename>/boot/grub/grub.cfg
remove all menuentry lines
replace with
menuentry "Offline Persistent Ubuntu - Bitcoin Armory" {
	set gfxpayload=keep
	linux	/casper/vmlinuz.efi  file=/cdrom/preseed/ubuntu.seed boot=casper persistent quiet splash noprompt --
	initrd	/casper/initrd.lz
}

echo the following into /volumes/<usbdrivename>/syslinux.cfg
default live
label live
  say Booting live Ubuntu session...
  kernel /casper/vmlinuz.efi
  append  file=/cdrom/preseed/ubuntu.seed boot=casper persistent initrd=/casper/initrd.lz quiet splash noprompt --




restart and hold option key down

run setup-offline.sh

enter password (aside mentioning wolfram alpha password entropy bits for education of reader)

if you wish, enter a keyfile path, although it is essentially adding another password onto your encrypted volume, and you will need it, in addition to your password, each time you decrypt your drive. i opt for no keyfile because I have a long secure password but I imagine there are some interesting applications such as using a system file or a zipped set of system files to ensure in order to decrypt the volume the system must have the same set of files in place as upon creation (e.g. password files)
type random characters used for the truecrypt random number generator (RNG). RNG is used to generate the master encryption key, among other things.

wait while it creates your encrypted volume

mount encrypted volume


Because we are operating offline we eliminate a lot of potential attack vectors but we are not immune to theft or the system becoming compromised. For this purpose encryption becomes the backbone of our security effort and hinges on choosing a strong passphrase!
