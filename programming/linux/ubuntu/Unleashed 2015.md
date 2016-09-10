# Ubuntu Unleashed 2015

## Ch 02 Background Information

Linux, pronounced **“lih-nucks,”** is free software. Combining the Linux kernel with GNU software tools—drivers, utilities, user interfaces, and other software such as the X.Org Foundation’s X Window System—creates a Linux distribution. There are many different Linux distributions from different vendors, but many derive from or closely mimic the Debian Linux distribution, on which Ubuntu is founded.

* A bootloader
* The Linux kernel
* Daemons
* The Shell
* Sell utilities
* A graphical server, such as X Server
* A desktop env, such as Unity
* Desktop software

### Getting the Most from Ubuntu and Linux Docs

* /usr/share/man
* /usr/share/doc

```shell
$ man man

# zless for .gz; less for text files.
$ less /usr/share/doc/httpd-2.0.50/README

# HTMLs
$ links /usr/share/doc/stunnel-4.0.5/stunnel.html

# or gv for .ps; evince for .pdf
```

## Ch 03 Working with Unity

Ubuntu uses the **X Window System**, **the graphical networking interface** found on many Linux distributions that **provides the foundation** for a wide range of **graphical tools and window managers**. More commonly known as just X, it can also be referred to as X11R7 and X11 (as found on Mac OS X). Coming from the MIT, X has gone through several versions, each of which has extended and enhanced the technology. The open-source implementation is managed by the X.Org foundation.

The best way to think about how X works is to see it as a **client/server system**. **The X server provides services to programs** that have been developed to make the most of the graphical and networking capabilities that are available under the server and in the supported libraries.

A desktop environment for X provides one or more window managers and a suite of clients that conform to a standard graphical interface based on a common set of software libraries. When used to develop associated clients, these libraries provide graphical consistency for the client windows, menus, buttons, and other onscreen components, along with some common keyboard controls and client dialogs.

### Basic X Concepts

The underlying engine of X11 is the X protocol, which provides a system of managing displays on local and remote desktops. The protocol uses a client/server model that allows an abstraction of the drawing of client windows and other decorations locally and over a network. An X server draws client windows, dialog boxes, and buttons that are specific to the local hardware and in response to client requests. The client, however, does not have to be specific to the local hardware. This means that system administrators can set up a network with a large server and clients and enable users to view and use those clients on workstations with totally different CPUs and graphics displays.



## Ch 09 Managing Software

Updating a full Ubuntu installation, including all the application software, is as simple as running the **Update Manager** program.

### GUI tools

Ubuntu proivdes a variety of tools for system resource management.

* Ubuntu Software
* Synaptic GUI
* Software Updater

Ubuntu is based on the Debian distribution, which has thousands of software packages available for installation. Ubuntu uses only a subset of that number but makes it easy for you to install the others, along with many packages that are not available in Debian.

### Command Line

With so much software available for installation, it is no surprise that Debian-based distros have many ways to manage software installation. At their root, they all use Debian's world-renowned *Advanced Package Tool(APT)*. 

APT is cool, it's the first system to properly handle dependencies in software. (Other distros, such as Red Hat, used RPM files that had dependencies).

APT, on the other hand, was designed to **automatically find and download dependencies for your packages**. So, if you want to install Gimp, it downloads Gimp’s package and any other software it needs to work. No more hunting around by hand, no more worrying about finding the right version, and certainly no more need to compile things by hand. APT also **handles installation resuming**, which means that if you lose your Internet connection part-way through an upgrade (or your battery runs out, or you have to quit, or whatever), APT picks up where it left off the next time you rerun it.

#### Day-to-Day Usage

To enable you to search for packages both quickly and thoroughly, APT uses a **local cache** of the available packages. Try running this command:

```shell
$ sudo apt-get update
```

APT maintains a package cache where it stores **DEB files** it has downloaded and installed. This usually lives in **/var/cache/apt/archives** and can sometimes take up many hundreds of megabytes on your computer. You can have APT clean out the package cache by running apt-get clean, which deletes all the cached DEB files. Alternatively, you can run apt-get autoclean, which deletes cached DEB files that are beyond a certain age, thereby keeping newer packages.

The apt-get update command instructs APT to contact all the servers it is configured to use and download the latest list of file updates. If your lists are outdated, it takes a minute or two for APT to download the updates. Otherwise, this command executes it in a couple of seconds.

After that, you can now ask APT to automatically download any software that has been updated, using this command:

```shell
$ sudo apt-get upgrade
```

The basic **apt-get upgrade never removes software or adds new software**. As a result, it is safe to use to keep your system fully patched because it should never break things. However, occasionally you will see the “0 not upgraded” status change, which means some things cannot be upgraded. This happens when some software must be installed or removed to satisfy the dependencies of the updated package, which, as previously mentioned, apt-get upgrade will never do.

In this situation, you need to use **apt-get dist-upgrade**, so named because it’s designed to allow users to upgrade from one version of Debian/Ubuntu to a newer version—an upgrade that inevitably involves changing just about everything on the system, removing obsolete software, and installing the latest features.

```shell
$ sudo apt-get install mysql-server

# or 

$ sudo apt-get install mysql-server mailx
```

If you want to remove packages, use:

```shell
$ sudo apt-get remove mailx
```

**Removing packages can be dangerous because APT also removes any software that
relies on the packages you selected.** For example, if you were to run apt-get remove libgtk2.0-0 (the main graphical toolkit for Ubuntu), you would probably find that APT insists on removing more than a hundred other things. The moral of the story is this: When you remove software, read the APT report carefully before pressing Y to continue with the uninstall.

A straight apt-get remove leaves behind the configuration files of your program so that if you ever reinstall it, you do not also need to reconfigure it. **If you want to remove the configuration files** as well as the program files, run this command instead:

```shell
$ sudo apt-get remove -purge mailx
```

#### Finding Software

```shell
# basic
$ apt-cache searche kde

# filter by name
$ apt-cache -n searche kde

# by reg exp
$ apt-cache -n searche ^kde

# perhaps the easiest way, combine apt-cache with grep
$ apt-cache searche games | grep kde

# check package info
$ apt-cache showpkg mysql-server-5.0
```

### Compiling Software from Source

Compiling applications from source is not that difficult. **There are two ways to do this**: You can use the source code available in the Ubuntu repositories, or you can use source code provided by upstream developers (most useful for those projects that are not available in the Ubuntu repositories). For either method, you need to install the package **build-essential** to ensure that you have the tools you need for compilation. You may also need to install **automake** and **checkinstall**, which are build tools.

#### Compiling from a Tarball

Most source code that is not in the Ubuntu repositories is available from the original writer or from a company’s website as compressed source **tarballs**—that is, **tar files that have been compressed using gzip or bzip**. The compressed files typically uncompress into a directory containing several files. It is always a good idea to **compile source code as a regular user** to limit any damage that broken or malicious code might inflict, so create a directory named source in your home directory.

```shell
# uncompress
$ tar zxvf packagename.tgz -C ~/source
$ tar zxvf packagename.tar.gz -C ~/source

$ tar jxvf packagename.bz -C ~/source
$ tar jxvf packagename.tar.bz2 -C ~/source

# cd to ~/source/packagename, check files named README, INSTALL

# compile
$ ./configure
$ make
$ sudo make install

# or
$ make clean
$ make uninstall
```

#### Compiling from Source from the Ubuntu Repositories

```shell
# get source
$ apt-get source foo
# install build dependencies
$ sudo apt-get build-dep foo

# cd to source code dir
$ cd foo-3.5.2
...

$ dch -i
$ debuild -S
...
$ sudo dpkg -0i foo-3.5.2-1ubuntu1custom.deb
```

### Config Management

* dotdee (dirs that end with a `.d` and store config files.
* OneConf

## Ch 10 Command-Line Quickstart

The command line is an efficient way to **perform complex tasks accurately** and much more easily than it would seem at a first glance. Knowledge of the commands available to you and also how to string them together makes using Ubuntu easier for many tasks.

### Accessing the CLI

* Unity -> Terminal
* Ctrl+Alt+F(1-6), go back to GUI: Ctrl+Alt+F7

#### Logging Out

* `exit`/`logout`
 
#### Logging In and Out from a Remote Computer

Note that you must have an account on the remote computer, and the remote computer must be configured to support remote logins; otherwise, you won’t be able to log in.

The best and most secure way to log in to a remote Linux computer is to use `ssh`, the **Secure Shell client**. Your login and session are encrypted while you work on the remote computer. The ssh client features many command-line options but can be simply used with the name or IP address of the remote computer.

Because you are using ssh, everything you enter on the keyboard in communication with the remote computer is encrypted.

### User Accounts

For the most part, only two types of people access the system as (human beings) users. Most people have a regular user account. These users can change anything that is **specific to their accounts**.

**To make systemwide changes, you need to use super user privileges**, such as can be done using the account you created when you started Ubuntu for the first time.

To use super user privileges from the cmd line, you need to preface the cmd with cmd `sudo`. An example of the destructive nature of working as the super user is the age-old example `sudo rm -rf /`, which erases everything on your hard drive.

**root** user, use `sudo passwd`.
use `sudo -i` to work as `root`.

### Reading Docs

* $ man rm -> (h for help, / for searching, q to quit)
* $ info man
* $ apropos partition (search commands by names and descriptions)
* $ whereis fdisk
* $ type fdisk

### Understanding the Linux File System Hierarchy

* /: the root dir
* /bin: essential commands
* /boot: boot loader files, Linux kernel
* /dev: device files
* /etc: system config files
* /home: user home dir (-> /home/username == ~)
* /lib: shared libs, kernel modules
* /lost+found: dir for recovered files (if found after a file system check)
* /media: mount point for **removable media, such as DVDs and floppy disks**
* /mnt: usual mount point for local, remote file systems
* /opt: add-on software packages
* /proc: kernel info, process control
* /root: super user home
* /sbin: system commands (mostly root only)
* /srv: holds info relating to services that run on your system
* /sys: real-time info on devices used by the kernel
* /tmp: temporary files
* /usr: software not essential for system operation, such as applications
* /var: variable data (such as logs); spooled files

View it
* `$ man hier`

#### Essential Commands in /bin and /sbin

The **/bin** directory contains essential commands used by the system for running and booting the system. In general, only the root operator uses the commands in the **/sbin** directory. The software in both locations is essential to the system; they make the system what it is, and if they are changed or removed, it could cause instability or a complete system failure. Often, the commands in these two directories are **statically linked**, which means that the commands do not depend on software libraries residing under the **/lib or /usr/lib** directories. **Nearly all the other applications on your system are dynamically linked**, meaning that they require the use of external software libraries (also known as shared libraries) to run. This is a feature for both sets of software.

#### Configuration Files in /etc

System configuration files and directories reside under the /etc directory. Some major software packages, such as Apache, OpenSSH, and xinetd, have their own subdirectories in /etc filled with configuration files. Others like crontab or fstab use one file. Examples of system-related configuration files in /etc include the following:

* fstab
* modprobe.d/
* passwd - list of users for the system
* sudoers

#### Use the Contents of the /proc dir to Interact with the Kernel

The content of the `/proc` directory is created from memory and exists only while Linux is running. This directory contains special files that either extract information from or send information to the kernel. Many Linux utilities extract information from dynamically created directories and files under this directory, also known as a virtual file system. For example, the `free` command obtains its information from a file named meminfo.

* `$ free`
* `$ cat /proc/meminfo`

The /proc directory can also be used to dynamically alter the behavior of a running Linux kernel by “echoing” numerical values to specific files under the /proc/sys directory. For example, to “turn on” kernel protection against one type of denial-of-service (DoS) attack known as SYN flooding, use the echo command to send the number 1 to the following /proc path:

* `$ sudo echo 1 >/proc/sys/net/ipv4/tcp_syncookies`

Other ways to use the /proc dir:

* Get CPU info: `$ less /proc/cpuinfo`
* Networking info: /proc/net, /proc/net/dev, /proc/net/route, /proc/net/netstat
* Retrieving file system info
* Reporting media mount point info via USB
* Getting the kernel version in /proc/version, perf info such as uptime in /proc/uptime, or other stats such as CPU load, swap file usage, and processes in /proc/stat

### Navigating the Linux File System

In the Linux file system, as with its predecessor UNIX, **everything is a file**: data files, binary files, executable programs, even input and output devices. These files are placed in a series of directories that act like file folders. **A directory is nothing more than a special type of file** that contains a list of other files/directories. These files and directories are used to create a hierarchical structure that enables logical placement of specific types of files.

* `ls`: list contents of a dir (ls -al, ls -R)
* `cd`
* `pwd`

### Working with Permissions

Under Linux (and UNIX), **everything in the file system, including directories and devices, is a file**. And every file on your system has an accompanying set of permissions based on ownership. These permissions provide data security by giving specific permission settings to every single item denoting who may **read, write, or execute** the file. These permissions are set individually for the file’s **owner**, **for members of the group** the file belongs to, and for **all others** on the system.

```shell
$ touch file

# the default permissions for a file
$ ls -l file

# -rw-rw-r-- 1 andersc andersc 0 2016-07-10 15:35 file
```

* type of file (-): -: file; d: dir; c: char device; b: block device;
* permissions: read, write, and execute for the owner, group and all others
* number of links to a file: (use `ln` cmd to create link), hard-linked file; symbolic link;
* owner: use `chown` to change it
* group: originally the file creator's main group, use `chgrp` to change it
* file size
* creation/modification date

#### Permissions

rwx -> 421, then rw-rw-r-- -> 664

**Altering with `chmod`**

You can use the **chmod command** to alter a file’s permissions. This command uses various forms of command syntax, including octal or a mnemonic form (such as u, g, o, or a and rwx, and so on) to specify a desired change. You can use the chmod command to add, remove, or modify file or directory permissions to protect, hide, or open up access to a file by other users (except for the root account or a user with super user permission and using sudo, **either of which can access any file or directory on a Linux system**).

**The mnemonic forms of `chmod`'s options are** (+ to add, - to remove):

* u - Adds or removes user (owner) read, write, or execute permission
* g - group
* o - others
* a - all users

* r - read
* w - write
* x - exe

```shell
# remove all write permission for anyone
$ chmod a-w file

# add rw for owner
$ chmod u+rw file

# use octal form
chmod 600 file
```

If you take away execution permission for a directory, **files might be hidden inside and may not be listed or accessed by anyone else** (except the root operator, of course, who has access to any file on your system). By using various combinations of permission settings, you can quickly and easily set up a more secure environment, even as a normal user in your `/home` directory.

**Change Group with `chgrp`**

```shell
$ chgrp wheel file
```

**Change Owner with `chown`**

**suid & sgid**

**chfn**

Files or programs that have suid or guid permissions can sometimes present security holes because they bypass normal permissions. This problem is compounded if the permission extends to an executable binary (a command) with an inherent security flaw because it could lead to any system user or intruder gaining root access. In past exploits, this typically happened when a user fed a vulnerable command with unexpected input (such as a long pathname or option); the command would fail, and the user would be presented a root prompt. Although Linux developers are constantly on the lookout for poor programming practices, new exploits are found all the time, and can crop up unexpectedly, especially in newer software packages that haven’t had the benefit of peer developer review.

Savvy Linux system administrators keep the number of suid or guid files present on
a system to a minimum. **The find command can be used to display all such files on your system**:

```shell
$ sudo find / -type f -perm /6000 -exec ls -l {} \;
```

### Working with Files

* `touch`: create an empty file, update date/time
* `mkdir`: make a dir (-p for recursive dirs)
* `rmdir`: remove a dir (if dir is empty, otherwise use `rm`)
* `rm`: remove a file or dir (nonempty, and -R recursively)
* `mv`: move or rename a file
* `cp`: copy a file
* `cat`: displaying the contents of a file
* `less`: displaying the *paged* contents of a file
* `more`: less is more:)

Each of these commands can be used with pattern-matching strings known as *wildcards* or *regular exp*.

* `$ rm abc*`

### Working as Root

**BAD***
`$ sudo rm -rf /` ...

Before editing any important system or software service config file, make a backup copy. Then make sure to **launch your text editor with line wrapping disabled**.

`$ sudo nano -w /etc/fstab`

**Understanding and Fixing sudo**

In order for a user to use sudo, the user account must **belong to the sudo group** and also be **listed in the /etc/sudoers file**. If both conditions are met, the user will be permitted to temporarily use root powers for specific commands that are issued at the command line by that user account by prefacing the command with the word sudo.

**Creating Users**

* `sudo adduser heather`
* `sudo passwd heather`

**Deleting Users**

* `sudo deluser --remove-all-files --remove-home heather`

**Shutting Down**

* `sudo shutdown -h now`
* `sudo shutdown -h 0`
* `sudo shutdown -h 18:30 "System shutting down message"` (msg to all active users)

**Rebooting the System**

* `sudo shutdown -r now`
* `sudo shutdown -r 0`

* `sudo halt/poweroff/reboot`

### Commonly Used Commands and Programs

* **Managing users and groups**: chage, chfn, chsh, edquota, gpasswd, groupadd, groupdel, groupmod, groups, mkpasswd, newgrp, newusers, passwd, umask, useradd, userdel, usermod
* **Managing files and file systems**: cat, cd, chattr, chmod, chown, compress, cp, dd, fdisk, find, gzip, ln, mkdir, mksfs, mount, mv, rm, rmdir, rpm, sort, swapon, swapoff, tar, touch, umount, uncompress, uniq, unzip, zip
* **Managing running programs**: bg, fg, kill, killall, nice, ps, pstree, renice, top, watch
* **Getting information**: apropos, cal, cat, cmp, date, diff, df, dir, dmesg, du, env, file, free, grep, head, info, last, less, locate, ls, lsattr, man, more, pinfo, ps, pwd, stat, strings, tac, tail, top, uname, uptime, vdir, vmstat, w, wc, whatis, whereis, which, who, whoami
* **Console text editors**: ed, jed, joe, mcedit, nano, red, sed, vim
* **Console Internet and network commands**: bing, elm, ftp, host, hostname, ifcon- fig, links, lynx, mail, mutt, ncftp, netconfig, netstat, pine, ping, pump, rdate, route, scp, sftp, ssh, tcpdump, traceroute, whois, wire-test


