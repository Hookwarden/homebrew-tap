class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://registry.npmjs.org/hookwarden/-/hookwarden-0.11.0.tgz"
  version "0.11.0"
  sha256 "f0dab4f85f02c713896254a861914f389c5170a939364fc6b12c6e43d6aeddaa"
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
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.11.0/hookwarden-linux-arm64"
      sha256 "2e8d97f5b28ebf77a3f0aaf7b41df48d32ca8c942a1f6290bd8442cdcc8a7917"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.11.0/hookwarden-linux-x64"
      sha256 "b05c255f1e1dd431a31ecbab0ef044bda4923466961b0d9a85cc8affe209e6bd"
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
