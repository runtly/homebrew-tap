# Homebrew formula for the runtly CLI.
#
# A meaningful share of the people this tool is for will never download a .dmg,
# and CI machines have no use for the GUI at all.
class Runtly < Formula
  desc "JavaScript runtime manager for macOS that tracks EOL and CVE exposure"
  homepage "https://runtly.flatium.com"
  version "0.1.0"
  # Proprietary: this formula belongs in runtly's own tap, never in
  # homebrew-core, which accepts only open source software.
  license :cannot_represent

  on_macos do
    url "https://dl.runtly.flatium.com/download/runtly-#{version}-macos-universal.tar.gz"
    # Replaced by the release pipeline.
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  end

  livecheck do
    url "https://dl.runtly.flatium.com/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  def install
    # Both binaries ship together: `runtly setup` looks for `runtly-shim` next
    # to the executable it is running from.
    libexec.install "runtly", "runtly-shim"
    bin.install_symlink libexec/"runtly"
  end

  def caveats
    <<~EOS
      Finish the installation with:
        runtly setup

      That installs the shims into ~/.runtly/bin and adds it to your shell's
      PATH, along with the `rt` alias. Open a new terminal afterwards.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runtly --version")
    # `doctor` exits non-zero until `setup` has run, so only the output is
    # checked here.
    assert_match "runtly doctor", shell_output("#{bin}/runtly doctor", 1)
  end
end
