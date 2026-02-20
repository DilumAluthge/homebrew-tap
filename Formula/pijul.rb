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

  bottle do
    root_url "https://github.com/DilumAluthge/homebrew-tap/releases/download/pijul-1.0.0-beta.11_1"
    sha256 cellar: :any,                 arm64_tahoe:   "8dfcff75c013c0aa33ffd76c4e0af8c1bb3a3ae65c586d044ffd92d155da2c19"
    sha256 cellar: :any,                 arm64_sequoia: "c5f2fa54f6c6c7c25257cda12535544b493872c0c818f93710c497324ba4740f"
    sha256 cellar: :any,                 arm64_sonoma:  "177de583c3e884463ec67c1edaae49bcd69fa78ff929669c2303a9cd8e7e4093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dacb3a32cab3fc0ea30eb03b22eb0c27e7dc1f96f8656448f8bedea5c00233c5"
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
