# The pijul formula was removed from homebrew-core in
# https://github.com/Homebrew/homebrew-core/commit/21702ef2c02ae7a5d925de7aed6defd0beefa93d
# This formula is based on the last version before removal
# Credit: Homebrew contributors
# License: BSD

class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://crates.io/api/v1/crates/pijul/1.0.0-beta.11/download"
  version "1.0.0-beta.11"
  sha256 "8a4fc27aa81ee061310d57fce2df9cc45f3149ddb00bdfab2b816beb0359b13d"
  license "GPL-2.0"
  revision 1

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

    # Ensure that the `libsodium-sys` crate picks up the intended libsodium library
    # https://github.com/sodiumoxide/sodiumoxide/blob/master/README.md#extended-usage
    ENV["SODIUM_USE_PKG_CONFIG"] = "1"

    # Build Pijul
    system "cargo", "build", "--release"

    # Install the Pijul binary into the Homebrew prefix:
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"pijul", "--no-prompt", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"pijul", "--no-prompt", "add", "haunted", "house"
    # pijul identity new --no-link --no-prompt --display-name 'Test User' --email 'noreply@example.com'
    # pijul --no-prompt record --all --message='Initial patch' --author='Test User <noreply@example.com>'
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end
