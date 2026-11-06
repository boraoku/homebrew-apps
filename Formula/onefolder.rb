class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app for macOS, Linux and Windows"
  homepage "https://github.com/boraoku/onefolder"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.5.0/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "1fb3ffc472e2e466858f167ff6dc5c6296c092e7c9ae13b43463e08eb8fd4341"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.5.0/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "ec7c82ad7a44d16d190b88ff733c72b319a1958c601f270a0c78dc7d7dbbebae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.5.0/onefolder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "73e25ca2b09379a7eeb344347c7a571c3f7d00a50b10ebb1f34a566b24dd89bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.5.0/onefolder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80d207702af00235beb0ff44faec7eb053945d4dfbe3183eb83aaf1e303837bb"
    end
  end
  license "MIT"
  depends_on "rclone"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "onefolder"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "onefolder"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "onefolder"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "onefolder"
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
