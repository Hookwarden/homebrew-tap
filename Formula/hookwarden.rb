class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://registry.npmjs.org/hookwarden/-/hookwarden-0.9.0.tgz"
  version "0.9.0"
  sha256 "df7f99a773b8debb033975f1f5954f96b9370a3afa41ed929f9d251deafd888d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # macOS: install the published npm tarball under libexec and symlink the bin.
  # We don't ship a darwin bun-compiled binary because notarisation requires
  # Apple Developer Program enrollment ($99/yr); the npm tarball is functionally
  # identical for end users and brew strips quarantine on install, so there's
  # no Gatekeeper friction. Tradeoff: depends on node at runtime (brew handles).
  on_macos do
    depends_on "node"
  end

  # Linux: standalone bun-compiled binaries from the GitHub Release.
  # These override the top-level npm-tarball URL.
  on_linux do
    on_arm do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.9.0/hookwarden-linux-arm64"
      sha256 "b0564327235963f1d0cf7a692675a0a3c04694a1e12b0ce26b950a4ab20849c8"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.9.0/hookwarden-linux-x64"
      sha256 "773261656aa44144fe875fc69cebf7d7e3da97153d4a15402105a6d4e843db0d"
    end
  end

  def install
    if OS.mac?
      system "npm", "install", *std_npm_args(prefix: libexec)
      bin.install_symlink Dir["#{libexec}/bin/*"]
    else
      bin.install Dir["*"].first => "hookwarden"
    end
  end

  def caveats
    <<~EOS
      Get started:
        hookwarden scan path/to/your/repo

      Documentation: https://hookwarden.dev
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookwarden --version")
  end
end
