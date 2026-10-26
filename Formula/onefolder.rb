class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app for macOS, Linux and WSL"
  homepage "https://github.com/boraoku/onefolder"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.1/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "9521883b9ffe8c0bf0f7ef6bce19ea6b78a0051089798c44048dde5ef352ceeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.1/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "2091668885bbe7002ed9c62a7fa929b37f2cbd71fe3966633a7dfd1e859bfe85"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.1/onefolder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "217f59a87abea479e181cc672bdaeeb6869c17f1729d8241bddbe99629d8f882"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.2.1/onefolder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7a977f238de3f81ad4f6e5366b0515d6537a32fb34b4190bbc5402189b4144c"
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
