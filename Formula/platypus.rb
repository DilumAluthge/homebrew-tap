# The platypus formula was removed from homebrew-core in
# https://github.com/Homebrew/homebrew-core/commit/d72fd20fcf630707a97b23316c2789d1b46fecb2
# This formula is based on the last version before removal
# Credit: Homebrew contributors
# License: BSD

class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://github.com/sveinbjornt/Platypus/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "4a12806aef43d13f67a6d55c765da6209b42543b421fadacaf3a2462c3e6221c"
  license "BSD-3-Clause"

  depends_on xcode: ["8.0", :build]
  depends_on :macos

  def install
    # Some debugging:
    puts Dir.pwd
    system "ls -la"

    system "make", "build_unsigned"
    # xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}/dst",
    #            "-project", "Platypus.xcodeproj",
    #            "-target", "platypus",
    #            "-target", "ScriptExec",
    #            "CODE_SIGN_IDENTITY=", "CODE_SIGNING_REQUIRED=NO",
    #            "clean",
    #            "install"

    # Some debugging:
    puts Dir.pwd
    system "ls -la"

    man1.install "CLT/man/platypus.1"
    bin.install "dst/platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
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
  end
end
