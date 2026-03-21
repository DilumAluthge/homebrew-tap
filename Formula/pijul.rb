# The pijul formula was removed from homebrew-core in
# https://github.com/Homebrew/homebrew-core/commit/21702ef2c02ae7a5d925de7aed6defd0beefa93d
# This formula is based on the last version before removal
# Credit: Homebrew contributors
# License: BSD

class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  # Crate: https://crates.io/crates/pijul
  url "https://crates.io/api/v1/crates/pijul/1.0.0-beta.11/download"
  version "1.0.0-beta.11"
  sha256 "8a4fc27aa81ee061310d57fce2df9cc45f3149ddb00bdfab2b816beb0359b13d"
  license "GPL-2.0"
  revision 2

  bottle do
    root_url "https://github.com/DilumAluthge/homebrew-tap/releases/download/pijul-1.0.0-beta.11_2"
    sha256 cellar: :any,                 arm64_tahoe:   "84c78c89dd9376f4896a3e0b3bfcd53e44dddbc8a621d5c16169822f023be032"
    sha256 cellar: :any,                 arm64_sequoia: "28b4a5439b6825da296f0c1568baa49136694a25be8b0f080d504703940898f5"
    sha256 cellar: :any,                 arm64_sonoma:  "fcb380a54756b1f04647354ad090396e8b81179cf077c39df36c8d924abf3d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1365e285de47134609b24f024c9f11054cecdb959e331c2069efb155e86ff537"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.75/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Build pijul, and install it into the Homebrew prefix:
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"pijul", "--no-prompt", "init"
    %w[haunted house].each { |f| touch testpath/f }
    assert_equal "No tracked files\n", shell_output("#{bin}/pijul ls")
    system bin/"pijul", "--no-prompt", "add", "haunted", "house"
    # pijul identity new --no-link --no-prompt --display-name 'Test User' --email 'noreply@example.com'
    # pijul --no-prompt record --all --message='Initial patch' --author='Test User <noreply@example.com>'
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end
