class Havm < Formula
  desc "Zero-config Home Assistant OS VM runner for Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  version "0.1.0"
  url "https://github.com/IngmarStein/havm/releases/download/v#{version}/havm.zip"
  sha256 "552e946697b777f874b8402feeee4f2d5bd3c7a9ce59b18700e3fcd1487889d2"
  license "MIT"

  depends_on macos: :golden_gate
  depends_on arch: :arm64

  def install
    libexec.install "Havm.app"
    bin.install_symlink libexec/"Havm.app/Contents/MacOS/havm" => "havm"

    (etc/"havm").mkpath
    (etc/"havm/config.yml").write <<~YAML
      # havm configuration — all fields optional, uncomment to customize.
      #
      # vm:
      #   cpu_count: 4
      #   memory_size: "4 GiB"
      #   disk_size: "32 GiB"
      #
      # network:
      #   type: nat
      #
      # ssh:
      #   authorized_keys: "~/.ssh/id_ed25519.pub"
      #
      # logging:
      #   format: text
      #   level: info
      #
      # shutdown:
      #   timeout_seconds: 30
    YAML
  end

  service do
    run [opt_bin/"havm", "run", "-c", etc/"havm/config.yml", "--data-dir", var/"lib/havm"]
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

      Config: #{etc}/havm/config.yml
      Data:   #{var}/lib/havm/
    EOS
  end

  test do
    system "#{bin}/havm", "version"
  end
end
