# Theos for Windows

A fork of [theos/theos](https://github.com/theos/theos) that natively builds iOS
tweaks on Windows, without WSL, without Cygwin setup, and without a macOS host.

Everything upstream needs on Linux has a Windows equivalent here:

- the LLVM toolchain ships as native Windows executables (`clang.exe`, `ld.exe`,
  `ldid.exe`, `plistutil.exe`, ...),
- `make` and every helper (`sed`, `awk`, `rsync`, `perl`, `tar`, `xz`, `curl`)
  come from [MSYS2](https://www.msys2.org/),
- the installer is the same `bin/install-theos` as upstream, extended with a
  `windows()` path that installs the dependencies with `pacman`, clones this
  fork, and unpacks the Windows toolchain and SDKs,
- vendored submodules are committed in-tree instead of being fetched by git.

## Install

Requirements: Windows 10 1803 or later and [MSYS2](https://www.msys2.org/).
`git` is needed to clone the repo; every other build dependency is installed by
the installer itself.

Open an MSYS2 shell (UCRT64 or MSYS) and run:

```sh
git clone https://github.com/JiJingren/theos-win.git ~/theos
~/theos/bin/install-theos
```

The installer runs `pacman -S --needed make perl rsync curl tar xz zip diffutils`,
downloads the toolchain and the iPhone SDKs, and adds `export THEOS=~/theos` to
your shell startup file. Restart the shell and run `$THEOS/bin/nic.pl` to create
a project.

## Build

```
cd /path/to/project
make package
```

The resulting `.deb` is written to `packages/`. Run `make` from an MSYS2 shell so
that `sed`, `awk`, `rsync`, `perl`, `tar`, and `xz` are available.

## Differences from upstream

- `makefiles/platform/Windows.mk` (aliased by `MINGW*`, `MSYS*`, and `Cygwin`)
  is the only platform file.
- `makefiles/targets/Windows/iphone.mk` points at the unprefixed Windows
  toolchain and supplies the `-target` triple itself.
- Helper scripts that upstream distributes as symlinks are plain files.
- `bin/fakeroot.sh` is a no-op, `bin/install.exec` runs commands directly
  instead of through `su`.
- `bin/install-theos` grows a `windows()` function; the root check is skipped
  and dependencies come from `pacman` instead of `sudo apt`.
- 32-bit ARM targets are unsupported, because the Windows `ld64` crashes on
  `armv6`/`armv7`/`armv7s` objects.

Upstream documentation applies otherwise; see
[theos.dev](https://theos.dev/docs/).
