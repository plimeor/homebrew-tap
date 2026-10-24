class Hum < Formula
  desc "Run background commands as launchd services, configured by TOML files"
  homepage "https://github.com/plimeor/hum"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0/hum-aarch64-apple-darwin.tar.xz"
      sha256 "f7dcabed7757e8f350bf3ebefe19ede024bb22127ff116db952dc1171fb60b71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0/hum-x86_64-apple-darwin.tar.xz"
      sha256 "887db235feebdebef8e590285e92f409aff269f621ae868cea6a10c599a98d9f"
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
