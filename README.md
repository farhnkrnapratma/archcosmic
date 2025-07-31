# ArchCOSMIC

## 🔮 A New Desktop Environment

COSMIC aims to liberate the computer with a new desktop environment powerful enough to build custom OS experiences for users, developers, and makers of any device with a screen.

> Homepage: https://system76.com/cosmic

This is a script to automate the installation process of the COSMIC desktop
environment on Arch Linux and its derivatives.

## 📍 Requirements

- ✅ `git` installed
- ✅ `base-devel` installed
- ✅ `yay` installed
- ⏺️ (Optional) `chaotic-aur` repo enabled

## 🛠️ Installation

> 📖 Note: All COSMIC desktop environment packages are installed from the Chaotic-AUR
repository. If you want to use the official version from the Arch Linux
repository, please add the `--arch` argument before running the installation
script.

### 1. 🚀 The fastest way: curl

Run the following in your terminal, then follow the onscreen instructions.

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/farhnkrnapratma/archcosmic/main/install-<version>.sh | sh
```

Or if you want to use the official version from the Arch Linux repo:

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/farhnkrnapratma/archcosmic/main/install-<version>.sh | sh -s -- --arch
```

### 2. 📋 Manual Installation

1. Clone the repository

```bash
$ git clone https://github.com/farhnkrnapratma/archcosmic.git
```

2. Navigate to the cloned repo

```bash
$ cd archcosmic
```

3. Verify the installation script authenticity (You probably should do this)

- Verify using `sha512sum`

```bash
$ sha512sum -c install-<version>.sh.sha512
```

If valid, you should see this:

```bash
install-v1.1.sh: OK
```

- Verify using `gpg`

```bash
$ gpg --verify install-<version>.sh.sig install-<version>.sh
```

If it is valid and the public key matches, you should see this:

```bash
gpg: Signature made Thu 31 Jul 2025 06:08:56 PM WIB
gpg:                using EDDSA key 0E8993B46423C2217F7E899BE9DE181A84887F4F
gpg: Good signature from "Farhan Kurnia Pratama (Farhan Kurnia Pratama PGP Key) <farhnkrnapratma@protonmail.com>" [ultimate]
```

5. Add execution permission for the script

```bash
$ chmod +x install-<version>.sh
```

5. Then, run the script and relax until the process is complete ☕

```bash
$ ./install-<version>.sh
# or ./install-<version>.sh --arch
```

## 🤔 What is Chaotic-AUR?

Chaotic-AUR is an automated build repository for AUR packages.

> Homepage: https://aur.chaotic.cx/

## 🐞 Report Problems

Report the issue by opening a pull request or send me an email to [farhnkrnapratma@protonmail.com](farhnkrnapratma@protonmail.com)

---

```
⚠️ DISCLAIMER OF WARRANTY AND LIABILITY

The software is provided "AS IS", without warranty of any kind, either express or implied,
including but not limited to the warranties of MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, and NON-INFRINGEMENT.

In no event shall the developer or any contributor be held liable for any DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, or CONSEQUENTIAL DAMAGES (including, but not limited to,
procurement of substitute goods or services; loss of use, data, or profits; or business
interruption) however caused and on any theory of liability, whether in contract, strict
liability, or tort (including negligence or otherwise) arising in any way out of the use of
this software, even if advised of the possibility of such damage.

USE AT YOUR OWN RISK.
```
