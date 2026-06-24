class Havm < Formula
  desc "Zero-config Home Assistant OS VM runner for Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  version "0.1.2"
  url "https://github.com/IngmarStein/havm/releases/download/v#{version}/havm.zip"
  sha256 "5711c8cf2d2b1c6681f0cc6cdc311fcbfc416cb24b5671cc7b81d00c7dbdb9dd"
  license "MIT"

  depends_on macos: :golden_gate
  depends_on arch: :arm64

  def install
    libexec.install "Havm.app"
    bin.install_symlink libexec/"Havm.app/Contents/MacOS/havm" => "havm"
  end

  service do
    run [opt_bin/"havm", "run", "-c", etc/"havm/config.yml", "--data-dir", var/"lib/havm"]
    keep_alive true
    run_type :immediate
    working_dir var/"lib/havm"
    log_path var/"log/havm.log"
    error_log_path var/"log/havm.log"
    environment_variables PATH: std_service_path_env
  end

  def post_install
    plist = launchd_service_path
    return unless plist.exist?

    safe_system "plutil", "-replace", "ExitTimeout", "-integer", "120", plist.to_s
  end

  def caveats
    <<~EOS
      Downloads and sets up Home Assistant OS automatically on first run.

      Data: #{var}/lib/havm/
      Optional config: #{etc}/havm/config.yml
    EOS
  end

  test do
    system "#{bin}/havm", "version"
  end
end
