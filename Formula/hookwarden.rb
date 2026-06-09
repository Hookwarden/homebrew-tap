class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://registry.npmjs.org/hookwarden/-/hookwarden-0.11.1.tgz"
  version "0.11.1"
  sha256 "82d4c99fd418be812e58c8626719afc11c6fb46a55a25f73712e60ef35a5b753"
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
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.11.1/hookwarden-linux-arm64"
      sha256 "8e0b4f2c4cfad3b71cb16d56f0e73cfd87657ed8a71c0be5591b07c90f2b093a"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.11.1/hookwarden-linux-x64"
      sha256 "79bd2d94e98bdffc53801092280c15e0607511834ba2702564befdaab58f3a04"
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
