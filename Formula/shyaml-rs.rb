class ShyamlRs < Formula
  desc "Command-line tool for working with YAML files"
  homepage "https://github.com/0k/shyaml-rs"
  # Crate: https://crates.io/crates/shyaml-rs
  url "https://crates.io/api/v1/crates/shyaml-rs/0.3.2/download"
  # version is automatically extracted from the url
  sha256 "46dbc216a9b92b5d82412ffa9114109f4500c8c02e4330588800d0edba264686"
  license "MIT"
  # revision 1

  bottle do
    root_url "https://github.com/DilumAluthge/homebrew-tap/releases/download/shyaml-rs-0.3.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b08a4b157d074dbb75866837ef88aba48fd149c72dd28c3313a3c402caf1ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e56b84c5686fdf18aed80a99e9c4895c12be47f41cdf82a3dc69e2797af156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a102f8b66fd299a845a6d694e673cd9b9020558e87e2d9748327af46c485aeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bfee4c25a49eea84bb4394da8d12888d9270f83c8beee5eefe2f48e7dc1738"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the desired library
    # https://docs.rs/openssl/0.10.75/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Build shyaml-rs from source, and install it into the prefix
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"shyaml", "--version"

    str = '{foo: "Hello", bar: "World", baz: "Goodbye"}'
    assert_equal "World", pipe_output("#{bin}/shyaml get-value bar", str)
  end
end
