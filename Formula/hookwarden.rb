class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://registry.npmjs.org/hookwarden/-/hookwarden-0.12.0.tgz"
  version "0.12.0"
  sha256 "ac1c8cc4e1b5f1b9632d07312adf3424b99877831fdc610be44b8b5b99bae467"
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
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.12.0/hookwarden-linux-arm64"
      sha256 "337bb82f5d3a18e62d10de6da62bdd27bc4d5efd37881c2510cde85e533209d7"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.12.0/hookwarden-linux-x64"
      sha256 "48239d7e34cc859fc6672ea0ec4b21c3032a22d9efa5343f75729e7bbd08d52e"
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
