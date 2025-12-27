cask "peazip" do
  # Use :latest to tell homebrew that this will always return the newest version, and there isn't a specific version number available.
  version :latest
  # Use :no_check to tell Homebrew that it can't know the checksum in advance, and so it should not try to validate the checksum of the downloaded archive.
  sha256 :no_check

  homepage "https://github.com/v-sukt/homebrew-cask-peazip"
  # If there's no arguments and only a block, Homebrew will wait to run the block until it actually needs the URL to download the file at install-time.
  url do
    # Homebrew has a built-in GitHub API client, conveniently able to provide the list of releases, converted from JSON to Ruby hashes.
    assets = GitHub.get_release("peazip", "PeaZip", "latest").fetch("assets")
    url = assets.find{|a| a["name"] == "*aarch64.dmg" }.fetch("url")
    # The return value must match the arguments for the non-block version of `url`, first a URL, and then an options hash. The `header` option can take an array if you need to provide more than one header.
    # [latest, header: [
      # The GitHub API will return the binary content of an asset instead of JSON data about that asset if you set the Accept header to application/octet-stream.
      # "Accept: application/octet-stream",
      # Homebrew also has a built-in helper that will return GitHub credentials, checking the keychain, config files, gh CLI tool, and other locations automatically. We can re-use those same credentials that Homebrew uses to make API requests for our own download by setting this header.
      # "Authorization: bearer #{GitHub::API.credentials}"
     # ]]
  end
  # desc "trying to get the latest release of peazip from it's GitHub page" 
  desc "#{url}"
  # url "https://github.com/peazip/PeaZip/releases/download/latest/peazip-#{version}.DARWIN.aarch64.dmg"

  app "PeaZip.app"
  caveats <<~EOS
    " #{url} "
    1. You may need to run the following command to use PeaZip.app (*):

      xattr -dr com.apple.quarantine /Applications/peazip.app

    2. As PeaZip's compiled binaries are unsigned, they will ask for permission to access certain paths on your machine the first time. On most macOS system versions it is sufficient to respond "OK" once to the system's permission request.      

    (*) If the system shows the error message "peazip.app is damaged and can’t be opened. You should move it to the Trash" or "peazip.app cannot be opened because the developer cannot be verified" the first time you run PeaZip, it simply means Safari has applied the "quarantine" attribute to the downloaded app package. Those warning messages are issue because the application's binaries are not signed (M1 version is simply ad-hoc signed, Intel version is not signed): to fix the error open the Terminal and run the aforementioned xattr command.
    
  EOS

end