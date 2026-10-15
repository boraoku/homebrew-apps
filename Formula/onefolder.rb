class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app for macOS, Linux and WSL"
  homepage "https://github.com/boraoku/onefolder"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.0/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "a15695c693c10c08b6c490c33dd51af57d45f272e8ede6cb06c6ef01a2f7853c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.0/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "5ffca9d6d4fa7c5d1948ebbbf8186da0b45dc4adf105228a0079196932c9d3bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.0/onefolder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a8b80d369c238d113955fe1ae7e7fca8ee0b11ef4f4788ed3fcbfc8759a8c8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.0/onefolder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "93c12b4a37ea28508dc253848a8413b6ebc80612c9a8f71742950eb5192cae92"
    end
  end
  license "MIT"
  depends_on "rclone"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
