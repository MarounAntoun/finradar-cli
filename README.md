# finradar-cli

Public distribution repository for the **FinRadar CLI** — a command-line client for
the [FinRadar](https://uat.finradarapi.com/integrations/cli) REST API.

This repository hosts the standalone pre-built binaries published on every
[GitHub Release](https://github.com/MarounAntoun/finradar-cli/releases/latest).
The source code is in a private repository; this repo only hosts public release artifacts.

---

## Install

### Homebrew (macOS / Linux)

```bash
brew install MarounAntoun/tap/finradar
```

### Scoop (Windows)

```powershell
scoop bucket add finradar https://github.com/MarounAntoun/scoop-finradar
scoop install finradar
```

### pip / pipx (all platforms, Python 3.9+)

```bash
pipx install finradar-cli
```

### Standalone binary — no Python required

Download the pre-built binary for your OS from the
[Releases page](https://github.com/MarounAntoun/finradar-cli/releases/latest):

```bash
# macOS / Linux
curl -sSL https://github.com/MarounAntoun/finradar-cli/releases/latest/download/finradar-linux \
  -o finradar
chmod +x finradar && sudo mv finradar /usr/local/bin/
```

Windows: download `finradar-windows.exe` from the Releases page and place it on your `PATH`.

---

## Update

The install method determines how you update:

| Install method | Update command |
|---|---|
| Standalone binary | `finradar update` (self-updates from this repo, sha256-verified) |
| pipx | `pipx upgrade finradar-cli` |
| pip | `pip install -U finradar-cli` |
| Homebrew | `brew upgrade finradar` |
| Scoop | `scoop update finradar` |

Standalone-binary users: if the CLI detects a newer release it will print a nudge
after any command. Run `finradar update` to apply it in one step — the binary
downloads the new release, verifies the sha256 sidecar, and atomically replaces
itself. No Python runtime needed.

---

## Verify

```bash
finradar --version
# finradar 0.1.0 (API spec 3.61.0; base https://uat.finradarapi.com)
```

---

## Documentation

Full CLI reference: <https://uat.finradarapi.com/integrations/cli>
