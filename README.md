# Hookwarden Homebrew Tap

Homebrew tap for [hookwarden](https://hookwarden.dev) — the webhook signature-verification audit tool.

## Install

    brew tap hookwarden/tap
    brew install hookwarden

## Verify

    hookwarden --version

## Supported platforms

- Linux arm64 (Linuxbrew)
- Linux x64 (Linuxbrew)

macOS is **not** currently supported via this tap (no funded Apple Developer
Program enrollment to sign binaries). macOS users should install via npm:

    npx hookwarden scan path/to/your/repo

Pre-built Linux binaries are pulled from
[Hookwarden/hookwarden GitHub Releases](https://github.com/Hookwarden/hookwarden/releases).
The formula is auto-bumped by hookwarden's release pipeline.

## License

Apache-2.0 — see LICENSE.
