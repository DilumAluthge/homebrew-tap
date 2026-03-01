class ShyamlRs < Formula
  desc "Command-line tool for working with YAML files"
  homepage "https://github.com/0k/shyaml-rs"
  # Crate: https://crates.io/crates/shyaml-rs
  url "https://crates.io/api/v1/crates/shyaml-rs/0.3.2/download"
  # version is automatically extracted from the url
  sha256 "46dbc216a9b92b5d82412ffa9114109f4500c8c02e4330588800d0edba264686"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/DilumAluthge/homebrew-tap/releases/download/shyaml-rs-0.3.2_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086eb08d70fa777fe0683e3f6f8ac369e79af2555847f8e5ffde6cfde8afbba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2294ebeffcfd349f1ba8ee9c07676f91df3ae7ca1a04b028c40c4a0dc726cd6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6563227b7194a4dadf5526465fae151936681247870ec309158f6bfd67ecfa36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15d5e29f9e7dccb14b703780cdbff5fdc41bb6f1aa55c44eef047382cc69c16"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  conflicts_with "shyaml", because: "both install `shyaml` binaries"

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
