class Hum < Formula
  desc "Run background commands as launchd services, configured by TOML files"
  homepage "https://github.com/plimeor/hum"
  version "0.1.0-rc.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0-rc.8/hum-aarch64-apple-darwin.tar.xz"
      sha256 "c42d3fc33f042255a7cb8e37eb45d0df76510b8c071b62d9ab85adeb5fc051dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plimeor/hum/releases/download/v0.1.0-rc.8/hum-x86_64-apple-darwin.tar.xz"
      sha256 "b615342854c0e6f7c75af36d22c93de0da18f49b1dab8325bad8d2d1e00c9204"
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
