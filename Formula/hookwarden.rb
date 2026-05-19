class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  version "0.3.0"
  license "Apache-2.0"

  # Linux-only: macOS binaries deferred (Apple Developer Program unfunded).
  # macOS users install via npm — see caveats.
  on_linux do
    on_arm do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-linux-arm64"
      sha256 "181abab1427d9bba4e79d95a4707a55083dee08d7ac4f6aff48a959acc613794"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-linux-x64"
      sha256 "c37b5ed9bc00c85c5b8021da0d3925ed1aac2b885651793a2d3137df4f34a64e"
    end
  end

  def install
    bin.install Dir["*"].first => "hookwarden"
  end

  def caveats
    <<~EOS
      hookwarden ships as a standalone binary. To get started:
        hookwarden scan path/to/your/repo

      Note: this formula provides Linux binaries only. macOS users should
      install via npm instead:
        npx hookwarden scan path/to/your/repo

      Documentation: https://hookwarden.dev
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookwarden --version")
  end

  livecheck do
    url :stable
    strategy :github_latest
  end
end
