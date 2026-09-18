# Homebrew cask for the runtly desktop app.
cask "runtly-app" do
  version "0.1.0"
  sha256 "97a7b77cfdcbca0880bec2d14abf6fc91ee6886210a131636259fcb42ab97bde"

  url "https://dl.runtly.flatium.com/download/runtly-#{version}-universal.dmg"
  name "runtly"
  desc "Manage Node, Bun, Deno and package managers, and audit their security posture"
  homepage "https://runtly.flatium.com"

  depends_on macos: ">= :catalina"

  livecheck do
    url "https://dl.runtly.flatium.com/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  app "runtly.app"

  # The app ships the CLI inside its bundle as a Tauri sidecar, which lands in
  # Contents/MacOS — not Contents/Resources. Linking it means `runtly` works in
  # a terminal without a second install.
  binary "#{appdir}/runtly.app/Contents/MacOS/runtly"

  zap trash: [
    "~/.runtly",
    "~/Library/Application Support/dev.runtly.app",
    "~/Library/Saved Application State/dev.runtly.app.savedState",
  ]

  caveats <<~EOS
    Run `runtly setup` once to install the shims and put ~/.runtly/bin on your
    PATH. Uninstalling with `brew uninstall --zap` removes the runtimes too.
  EOS
end
