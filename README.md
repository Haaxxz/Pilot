# Eta

An iOS application built with Swift and managed via XcodeGen.

## Building the App

This project uses a GitHub Actions workflow to automatically build an **unsigned `.ipa`** file that can be installed on your device using SideStore, ESign, AltStore, or similar sideloading tools.

Because compiling an iOS app requires a macOS environment, the GitHub Action takes care of this for you. 

### How to get the IPA:
1. Push your code changes to GitHub.
2. Go to the **Actions** tab in your repository.
3. Click on the most recent workflow run for **Build Unsigned IPA**.
4. Scroll down to the **Artifacts** section at the bottom of the page.
5. Download the `Eta-Unsigned-IPA` zip file.
6. Extract the zip file to get the `Eta.ipa` file.

### Sideloading
You can now transfer the `Eta.ipa` file to your iOS device and install it via:
* **SideStore** / **AltStore**: Tap the `+` button in the My Apps tab and select the `.ipa`.
* **ESign**: Import the `.ipa`, sign it with your chosen certificate, and install.

## Local Development (macOS only)

If you are on a Mac and wish to develop locally:

1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen):
   ```bash
   brew install xcodegen
   ```
2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```
3. Open `Eta.xcodeproj` in Xcode.

