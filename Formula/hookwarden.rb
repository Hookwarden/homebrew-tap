class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  url "https://github.com/Hookwarden/hookwarden/releases/download/v0.3.1/hookwarden-linux-arm64"
  sha256 "b1c35628278c2f8ea40fecdc330b0bf891ca0535671e663fd98ab6d5fd03d049"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Linux-only release. Top-level url/sha = on_arm spec; on_linux/on_intel
  # overrides for x64. depends_on :linux blocks install on macOS with a
  # clean error; macOS users install via npm — see caveats.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v0.3.1/hookwarden-linux-x64"
      sha256 "79e6e4e0fcf1010ce4182d5bcb5095324ead68fe4bb3f9800e4209f781e487b3"
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
end
