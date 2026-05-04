class Hookwarden < Formula
  desc "Webhook signature-verification audit tool"
  homepage "https://hookwarden.dev"
  version "0.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-darwin-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-linux-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/Hookwarden/hookwarden/releases/download/v#{version}/hookwarden-linux-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install Dir["*"].first => "hookwarden"
  end

  def caveats
    <<~EOS
      hookwarden ships as a standalone binary. To get started:
        hookwarden scan path/to/your/repo
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
