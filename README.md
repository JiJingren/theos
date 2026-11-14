# Theos for Windows (MSYS2)

A fork of [theos/theos](https://github.com/theos/theos) that natively builds iOS
tweaks on Windows, without WSL, without Cygwin setup, and without a macOS host.

Everything upstream needs on Linux has a Windows equivalent here:

- the LLVM toolchain ships as native Windows executables (`clang.exe`, `ld.exe`,
  `ldid.exe`, `plistutil.exe`, ...),
- `make`, the shell, and every helper (`sed`, `awk`, `rsync`, `perl`, `tar`,
  `xz`, `curl`) are bundled, so no MSYS2 installation is required,
- vendored submodules are committed in-tree instead of being fetched by git.

## Install

Download the latest release from
[Releases](https://github.com/JiJingren/theos-win/releases/latest), unpack it
anywhere, and run `install-theos` from the bundled shell:

```
.\msys\run.bat
cd /path/to/theos-win/theos
./bin/install-theos
```

The installer downloads the toolchain and the iPhone SDKs, then adds `THEOS` to
your `~/.bashrc`. Restart the shell and run `$THEOS/bin/nic.pl` to create a
project.

## Build

```
cd /path/to/project
make package
```

The resulting `.deb` is written to `packages/`.

## Differences from upstream

- `makefiles/platform/Windows.mk` (aliased by `MINGW*`, `MSYS*`, and `Cygwin`)
  is the only platform file; `install-theos` never invokes `sudo`, `fakeroot`,
  or a package manager.
- `makefiles/targets/Windows/iphone.mk` points at the unprefixed Windows
  toolchain and supplies the `-target` triple itself.
- Helper scripts that upstream distributes as symlinks are plain files.
- `bin/fakeroot.sh` is a no-op, `bin/install.exec` runs commands directly
  instead of through `su`.

Upstream documentation applies otherwise; see
[theos.dev](https://theos.dev/docs/).
