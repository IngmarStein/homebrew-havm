class Havm < Formula
  desc "Zero-config Home Assistant OS VM runner for Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  url "https://github.com/IngmarStein/havm/releases/download/v1.0.0/havm.zip"
  sha256 "ce3a00e1a05b60aa090ec8452878576044a91e3e9efcc9431d6e961f9e57c4e2"
  license "MIT"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  def install
    libexec.install "Havm.app"
    bin.install_symlink libexec/"Havm.app/Contents/MacOS/havm" => "havm"
    generate_completions_from_executable(bin/"havm", "--generate-completion-script", shells: [:bash, :zsh, :fish])
  end

  service do
    run [opt_bin/"havm", "run", "-c", etc/"havm/config.yml", "--data-dir", var/"lib/havm"]
    keep_alive true
    run_type :immediate
    working_dir var/"lib/havm"
    log_path var/"log/havm.log"
    error_log_path var/"log/havm.log"
    stop_timeout 120
    environment_variables PATH: std_service_path_env
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
