# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

This is a Homebrew **tap** (external formula repository) providing the `havm` formula — a zero-config Home Assistant OS VM runner for Apple Silicon using the native Virtualization framework. It requires macOS 27 (Golden Gate) on arm64.

## Key commands

```bash
# Audit the formula (style + correctness checks)
brew audit --tap IngmarStein/havm

# Test the formula
brew test-bot --tap IngmarStein/havm --only-formulae
```

## Architecture

The repo consists of a single Homebrew formula file (`havm.rb`) — the standard structure for a minimal tap.

### Formula pattern

- **`Havm.app` bundle** is installed to `libexec/` (an `.app` in libexec prevents `brew` from auto-cd'ing into a single subdirectory). The CLI binary lives at `Havm.app/Contents/MacOS/havm`.
- A **symlink** from `bin/havm` points into the app bundle so `havm` is on `PATH`.
- The **`service` block** defines a launchd user service that runs `havm run -c <config> --data-dir <data>` in immediate keepalive mode.
- **`post_install`** patches the generated launchd plist to set `ExitTimeout` to 120 seconds.
- **`caveats`** shows where data and optional config live (under `var/` and `etc/` respectively).

### Updating for a new release

1. Update `version` to the new tag.
2. Compute the new `sha256` with `shasum -a 256 havm.zip`.
3. Update `url` if the download naming scheme changed.
4. Run `brew audit` and `brew test-bot` as above.
