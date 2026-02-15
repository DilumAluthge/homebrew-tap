# The pijul formula was removed from homebrew-core in
# https://github.com/Homebrew/homebrew-core/commit/21702ef2c02ae7a5d925de7aed6defd0beefa93d
# This formula is based on the last version before removal
# Credit: Homebrew contributors
# License: BSD

class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://crates.io/api/v1/crates/pijul/#{version}/download"
  version "1.0.0-beta.11"
  sha256 "8a4fc27aa81ee061310d57fce2df9cc45f3149ddb00bdfab2b816beb0359b13d"
  # revision 1

  bottle do
    root_url "https://github.com/DilumAluthge/homebrew-tap/releases/download/pijul-1.0.0-beta.11"
    sha256 cellar: :any,                 arm64_tahoe:   "9e6d1fc4772ef4ae7cd384c647fb086db91945938f1ec6613f2bf8f56765a394"
    sha256 cellar: :any,                 arm64_sequoia: "7fc6c03380fb292b544125023a037c393812e0d068d59215bacccca5733a102a"
    sha256 cellar: :any,                 arm64_sonoma:  "d2d1883e76758ceef62e956b6bd5035a9a29f28937392a26d1c270ee2e93be42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a59368f736c3f22094b9f221d81649dc3f83bdf6730511241c7871dc00cc96"
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
    system bin/"pijul", "--no-prompt", "add", "haunted", "house"
    # pijul identity new --no-link --no-prompt --display-name 'Test User' --email 'noreply@example.com'
    # pijul --no-prompt record --all --message='Initial patch' --author='Test User <noreply@example.com>'
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end
