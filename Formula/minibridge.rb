class Minibridge < Formula
  desc "Bridge that runs Aside commands for the Aside phone app"
  homepage "https://github.com/0x962/aside-mobile-manager"
  url "https://github.com/0x962/aside-mobile-manager/releases/download/bridge-v1.0.2/minibridge-1.0.2.tar.gz"
  sha256 "ca8cf7551679e6c7c42bb65c65bde7f9d6080e10b6064e187e29b47c2050bf71"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    libexec.install Dir["*"]

    # node-pty carries a prebuilt binary for every platform. Keep this one.
    native = "darwin-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    prebuilds = libexec/"node_modules/node-pty/prebuilds"
    prebuilds.children.each { |dir| rm_r dir if dir.basename.to_s != native }
    chmod 0755, prebuilds/native/"spawn-helper"

    bin.install_symlink libexec/"bin/minibridge.mjs" => "minibridge"
  end

  def caveats
    <<~EOS
      Start the bridge, which shows a pairing code on first run:
        brew services start minibridge

      If you installed the bridge with the curl script before this, it left its
      own launchd agent that holds port 4720. Remove it, or the Homebrew service
      cannot start:
        launchctl bootout gui/$(id -u)/co.nvdk.minibridge
        rm ~/Library/LaunchAgents/co.nvdk.minibridge.plist
    EOS
  end

  service do
    run [opt_bin/"minibridge", "serve"]
    keep_alive true
    log_path var/"log/minibridge.log"
    error_log_path var/"log/minibridge.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minibridge --version")
  end
end
