#!/bin/sh
# FinRadar CLI installer.
#
#   curl -fsSL https://raw.githubusercontent.com/MarounAntoun/finradar-cli/main/install.sh | sh
#
# Downloads the standalone binary for your OS from the latest GitHub release,
# VERIFIES its sha256 against the published sidecar, and installs it to PATH.
# Nothing is installed unless the checksum matches.
#
# Overrides (env):
#   FINRADAR_VERSION      pin a release tag, e.g. cli-v0.1.0   (default: latest)
#   FINRADAR_INSTALL_DIR  install location                     (default: ~/.local/bin)
set -eu

REPO="MarounAntoun/finradar-cli"
API="https://api.github.com/repos/${REPO}"
DL="https://github.com/${REPO}/releases/download"

say() { printf '%s\n' "$*"; }
err() { printf 'error: %s\n' "$*" >&2; exit 1; }

# --- prerequisites ---
command -v curl >/dev/null 2>&1 || err "curl is required."
if command -v sha256sum >/dev/null 2>&1; then sha() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum  >/dev/null 2>&1; then sha() { shasum -a 256 "$1" | cut -d' ' -f1; }
else err "need 'sha256sum' or 'shasum' to verify the download."; fi

# --- pick the asset for this OS ---
os="$(uname -s)"
case "$os" in
  Linux)  asset="finradar-linux" ;;
  Darwin) asset="finradar-macos" ;;   # built on Apple Silicon; Intel Macs: use 'pipx install finradar-cli'
  *) err "unsupported OS '$os'. On Windows use Scoop ('scoop install finradar') or 'pipx install finradar-cli'." ;;
esac

# --- resolve the release tag (latest unless pinned) ---
tag="${FINRADAR_VERSION:-}"
if [ -z "$tag" ]; then
  tag="$(curl -fsSL "${API}/releases/latest" | grep -m1 '"tag_name"' | cut -d'"' -f4)"
fi
[ -n "$tag" ] || err "could not determine the latest release tag (no releases yet?)."
say "Installing FinRadar CLI ${tag} for ${os}..."

# --- download binary + sidecar to a private temp dir ---
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM
curl -fsSL "${DL}/${tag}/${asset}"         -o "${tmp}/finradar"        || err "download failed: ${asset}"
curl -fsSL "${DL}/${tag}/${asset}.sha256"  -o "${tmp}/finradar.sha256" || err "download failed: ${asset}.sha256"

# --- VERIFY sha256 before doing anything with the file ---
expected="$(cut -d' ' -f1 < "${tmp}/finradar.sha256" | tr -d '[:space:]')"
actual="$(sha "${tmp}/finradar")"
[ -n "$expected" ] || err "empty checksum sidecar — refusing to install."
if [ "$expected" != "$actual" ]; then
  err "sha256 MISMATCH — refusing to install (expected ${expected}, got ${actual})."
fi
say "sha256 verified."
chmod +x "${tmp}/finradar"

# --- install (default to a user-writable dir so no sudo is needed in 'curl | sh') ---
dir="${FINRADAR_INSTALL_DIR:-${HOME}/.local/bin}"
mkdir -p "$dir" || err "cannot create ${dir}."
if [ -w "$dir" ]; then
  mv "${tmp}/finradar" "${dir}/finradar"
elif command -v sudo >/dev/null 2>&1; then
  say "Elevating with sudo to write ${dir}..."
  sudo mv "${tmp}/finradar" "${dir}/finradar"
else
  err "${dir} is not writable and sudo is unavailable. Set FINRADAR_INSTALL_DIR to a writable dir."
fi

say "Installed: ${dir}/finradar"
case ":${PATH}:" in
  *":${dir}:"*) ;;
  *) say "NOTE: ${dir} is not on your PATH. Add it, e.g.:  export PATH=\"${dir}:\$PATH\"" ;;
esac
"${dir}/finradar" --version 2>/dev/null || say "(installed; ensure ${dir} is on your PATH, then run: finradar --version)"
say "Done. Try 'finradar --help'. Standalone binaries self-update with 'finradar update'."
