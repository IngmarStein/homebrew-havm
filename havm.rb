class Havm < Formula
  desc "Zero-config CLI for running Home Assistant OS on Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  url "https://github.com/IngmarStein/havm/releases/download/v0.1.0/havm.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"
  version "0.1.0"

  depends_on macos: :golden_gate

  def install
    bin.install "havm"
  end

  test do
    system "#{bin}/havm", "version"
  end
end
