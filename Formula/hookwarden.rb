class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://registry.npmjs.org/hookwarden/-/hookwarden-0.5.5.tgz"
  version "0.5.5"
  sha256 "4231bc79d8fbde293a428f7ef3ff213749b0335374da5b688472a4e03d2ced20"
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
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.5.5/hookwarden-linux-arm64"
      sha256 "4708b78c8a47f52db2f08199d55eedc74ddc859a2f63d692e6ed87dc8ec5e580"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.5.5/hookwarden-linux-x64"
      sha256 "b8efcb97f79bcc7e14f419af485039bc6d8b30fff6e889a5494db79a5343a313"
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
