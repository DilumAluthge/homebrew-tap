# The platypus formula was removed from homebrew-core in
# https://github.com/Homebrew/homebrew-core/commit/d72fd20fcf630707a97b23316c2789d1b46fecb2
# This formula is based on the last version before removal
# Credit: Homebrew contributors
# License: BSD

class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://github.com/sveinbjornt/Platypus/archive/refs/tags/v5.5.0.tar.gz"
  # version is automatically extracted from the url
  sha256 "4a12806aef43d13f67a6d55c765da6209b42543b421fadacaf3a2462c3e6221c"
  license "BSD-3-Clause"
  # revision 1

  depends_on "make" => :build
  depends_on xcode: ["8.0", :build]
  depends_on :macos

  def install
    # Build Platypus
    system "make", "build_unsigned"

    # Install binary, and man page
    bin.install "products/platypus_clt" => "platypus"
    man1.install "CLT/man/platypus.1"

    # Install sub-binary parts to share
    # Without this, platypus is not runnable
    # https://github.com/Homebrew/homebrew-core/issues/18734
    cd "products/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats
    <<~EOS
      This formula only installs the command-line Platypus tool, not the GUI.

      The GUI can be downloaded from the Platypus website:
        https://sveinbjorn.org/platypus
    EOS
  end

  test do
    system bin/"platypus", "--version"
    system bin/"platypus", "--help"
  end
end
