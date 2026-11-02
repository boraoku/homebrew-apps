class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app for macOS, Linux and WSL"
  homepage "https://github.com/boraoku/onefolder"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.2/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "0c7d66ba5e342bc513a07ff955349132fd178bf923937a0aa60a03eaa0136df4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.2/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "205b5fc1ba42284a1075defdf0b2373c4eddf7278fbf0351235f979c28eda22b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.2/onefolder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "adbaa327ceeaf2842b92c1479e6504d33ef5f57285535dbea7b9472e8bafa60e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.2/onefolder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f94755183b4033e5e7838bced4612079f5dcf787b7a9770a6688afcece9907ed"
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
