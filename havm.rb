class Havm < Formula
  desc "Zero-config Home Assistant OS VM runner for Apple Silicon"
  homepage "https://github.com/IngmarStein/havm"
  version "0.1.0"
  url "https://github.com/IngmarStein/havm/releases/download/v#{version}/havm.zip"
  sha256 "1db584527f8ac88e35a43b88e3411b1ab7a1311ef5841e26a70c5486172f59ce"
  license "MIT"

  depends_on macos: :golden_gate
  depends_on arch: :arm64

  def install
    libexec.install "Havm.app"
    bin.install_symlink libexec/"Havm.app/Contents/MacOS/havm" => "havm"

    (etc/"havm").mkpath
    (etc/"havm/config.yml").write <<~YAML
      # havm configuration — all fields optional, havm works with zero config.
      #
      # vm:
      #   cpu_count: 4
      #   memory_size: "4 GiB"
      #   disk_size: "32 GiB"
      #
      # network:
      #   type: nat                  # nat (default) or bridge
      #
      # haos:
      #   release_channel: stable    # stable (default) or pre-release
      #
      # ssh:
      #   authorized_keys: "~/.ssh/id_ed25519.pub"
      #
      # logging:
      #   format: text               # text (default) or json
      #   level: info                # debug, info (default), warning, error
      #
      # shutdown:
      #   timeout_seconds: 30
    YAML
  end

  service do
    run [opt_bin/"havm", "run", "--config", etc/"havm/config.yml"]
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
      User override: ~/.config/havm/config.yml
      Data: ~/Library/Application Support/havm/
    EOS
  end

  test do
    system "#{bin}/havm", "version"
  end
end
