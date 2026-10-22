class Hum < Formula
  desc "Run background commands as launchd services, configured by TOML files"
  homepage "https://github.com/plimeor/hum"
  version "0.1.0-rc.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0-rc.5/hum-aarch64-apple-darwin.tar.xz"
      sha256 "8c35865073d5e95568cbe9efedd26a745c34cdf1bdd4691ddde7d7625a11f745"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0-rc.5/hum-x86_64-apple-darwin.tar.xz"
      sha256 "ac4873945b0a144431819d9b5ec37d17d5c64e45128d359cbf1da33598134693"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hum"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hum"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
