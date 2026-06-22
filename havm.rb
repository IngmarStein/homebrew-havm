class Havm < Formula
  desc "Zero-config Home Assistant OS VM runner for Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  version "0.1.0"
  url "https://github.com/IngmarStein/havm/releases/download/v#{version}/havm.zip"
  sha256 "2eba8e4bdc3336b559ae4c0940927d71752a2633ac8bbc5422b23e060bd66132"
  license "MIT"

  depends_on macos: :golden_gate
  depends_on arch: :arm64

  def install
    libexec.install "Havm.app"
    bin.install_symlink libexec/"Havm.app/Contents/MacOS/havm" => "havm"
  end

  service do
    run [opt_bin/"havm", "run", "--data-dir", var/"lib/havm"]
    keep_alive true
    run_type :immediate
    working_dir var/"lib/havm"
    log_path var/"log/havm.log"
    error_log_path var/"log/havm-error.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Downloads and sets up Home Assistant OS automatically on first run.

      Data: #{var}/lib/havm/
      Config (optional): ~/.config/havm/config.yml
    EOS
  end

  test do
    system "#{bin}/havm", "version"
  end
end
