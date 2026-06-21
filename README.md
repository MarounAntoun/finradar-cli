# FinRadar CLI

`finradar` — a command-line client for the [FinRadar](https://uat.finradarapi.com) REST API
(SEC filings, 13F institutional holdings, insider transactions, financials, and more).

This repository hosts the **standalone binary releases** + their `*.sha256` sidecars.
The Python package is on PyPI; the source is maintained privately.

## Install

**curl (macOS / Linux) — one command, sha256-verified:**
```sh
curl -fsSL https://raw.githubusercontent.com/MarounAntoun/finradar-cli/main/install.sh | sh
```
Installs the latest standalone binary to `~/.local/bin` after verifying its checksum.
Pin a version or change the location:
```sh
curl -fsSL https://raw.githubusercontent.com/MarounAntoun/finradar-cli/main/install.sh | FINRADAR_VERSION=cli-v0.1.0 FINRADAR_INSTALL_DIR=/usr/local/bin sh
```

**Homebrew (macOS / Linux):**
```sh
brew install MarounAntoun/tap/finradar
```

**Scoop (Windows):**
```powershell
scoop bucket add finradar https://github.com/MarounAntoun/scoop-finradar
scoop install finradar
```

**pip / pipx (any OS with Python 3.10+):**
```sh
pipx install finradar-cli      # or: pip install finradar-cli
```

**Manual binary download:** grab the asset for your OS from the
[latest release](https://github.com/MarounAntoun/finradar-cli/releases/latest)
and verify it against its `.sha256` sidecar.

## Updating

- Standalone binary: `finradar update` (self-updates from this repo's releases, sha256-verified).
- pip / pipx: `pipx upgrade finradar-cli`  •  Homebrew: `brew upgrade finradar`  •  Scoop: `scoop update finradar`.

## Platform notes

- The **Linux** binary is built on a recent toolchain and currently requires **glibc ≥ 2.38**
  (Ubuntu 24.04+, Debian 13+, Fedora 39+). On older Linux, use `pipx install finradar-cli`.
- The **macOS** binary is built for Apple Silicon. On Intel Macs, use `pipx install finradar-cli`.

## Getting started
```sh
finradar configure              # save your API key
finradar sec filings search --ticker AAPL --form_type 4
finradar 13f fund show 1067983  # Berkshire Hathaway holdings
finradar --help
```
