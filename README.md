# Homebrew tap

Formulae for the [Aside phone app](https://github.com/0x962/aside-mobile-manager).

## minibridge

The bridge that runs Aside commands on your computer for the phone app.

```
brew install 0x962/tap/minibridge
brew services start minibridge
minibridge pair
```

`minibridge pair` opens a QR code on this computer's screen. Scan it in the app to pair the phone. Only a device that scans a code can reach the bridge.
