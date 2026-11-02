class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app for macOS, Linux and WSL"
  homepage "https://github.com/boraoku/onefolder"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.1/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "8238178809b4d278a4796852780b90b28b745cd676937a37f6681837bc8efdf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.1/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "ea1dc94f1cd8ee55e7e594f89273f41303c1db2f9c393e1c0e907cd154e5f29f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.1/onefolder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "017e2f745c2b8fd586a28de05347f187ffd1fed57f125c374867143f5ca60553"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.4.1/onefolder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "140d28ba4fae20bcec610b46c40b3bf6be6bec217f3dc576ce090a0921ecf204"
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
