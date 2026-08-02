class Minibridge < Formula
  desc "Bridge that runs Aside commands for the Aside phone app"
  homepage "https://github.com/0x962/aside-mobile-manager"
  url "https://github.com/0x962/aside-mobile-manager/releases/download/bridge-v1.0.0/minibridge-1.0.0.tar.gz"
  sha256 "62aefafa04a6764012d883dcea7bf3b6edbcfab2829cfd40d499777b0a9b8987"
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
