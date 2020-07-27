# 0. Overview
"AboutWindow" is a rewrite of Danger Cove's Objective-C framework "[DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)" in Swift.
Currently, there is no cocoapods support.

AboutWindow is a replacement for the standard About dialog.
It adds the option to open acknowledgments and visit the website by clicking a button.

![DCOAboutWindow in action](https://raw.github.com/DangerCove/DCOAboutWindow/master/screenshots/DCOAboutWindow.png)
![DCOAboutWindow in Dark Mode](https://raw.github.com/DangerCove/DCOAboutWindow/master/screenshots/DCOAboutWindow-DarkMode.png)

## 0.1. Showing acknowledgments
You can point to and maintain a custom `Acknowledgments.rtf` file, or you can use a script like [Acknowledge](https://github.com/DangerCove/Acknowledge) to generate it for you.

# 1. Setup
## 1.1. via [Swift Package Manager](https://swift.org/package-manager/)
The Swift Package Manager is a tool for automating the distribution of Swift libraries/frameworks and is integrated into the swift compiler. Once your Swift package is set up, you can add AboutWindow as a `dependency` as easy as adding it to the ‘dependencies' value in `Package.swift`.

## 1.2. via [carthage](https://github.com/Carthage/Carthage)
Add the following to your Cartfile:
```bash
github "stein2nd/AboutWindow"
github "stein2nd/TransparentScroller"
```
Then run `carthage update` and you're set.

## 1.3. Manually
Clone this repo and add files from `DCOAboutWindow` to your project.
The project relies on [TransparentScroller](https://github.com/stein2nd/TransparentScroller), so include that too.

# 2. Usage
I've made a [sample project](https://github.com/DangerCove/DCOAboutWindowExample) that accompanies this tiny guide.

Import `AboutWindow`:
```swift
import AboutWindow
```

Instantiate `AboutWindowController`:
```swift
/// The window controller that handles the about window.
private var _aboutWindowController: AboutWindowController?

/// The window controller that handles the about window.
private var aboutWindowController: AboutWindowController? {
	if self._aboutWindowController == nil {
		self._aboutWindowController = AboutWindowController.init()
	}
	return self._aboutWindowController
}
```

Create an IBAction to display the window:
```swift
@IBAction func showAboutWindow(_ sender: Any) {
	// Show the about window
	self.aboutWindowController?.showWindow(nil)
}
```

Hook it up to the 'About [app name]' menu item or a button.

You can change values by setting properties on `AboutWindowController`:
```swift
/// The application name.
/// Default: CFBundleName
var appName: String?

/// The application version.
/// Default: "Version %1@ (Build %2@)", CFBundleVersion, CFBundleShortVersionString
var appVersion: String?

/// The copyright line.
/// Default: NSHumanReadableCopyright
var appCopyright: String?

/// The credits.
/// Default: contents of file at Bundle.main.path(forResource: "Credits", ofType: "rtf")
var appCredits: NSAttributedString?

/// The URL pointing to the app's website.
/// Default: nil
var appWebsiteURL: URL?

/// The path to the file that contains the acknowledgments.
/// Default: Bundle.main.path(forResource: "Acknowledgments", ofType: "rtf")
var acknowledgmentsPath: String?

/// If set to true acknowledgments are shown in a text view, inside the window. Otherwise an external editor is launched.
/// Default: false
var useTextViewForAcknowledgments = false
```

## 2.1. Pre-processing (for Dark Mode)
You can pre-process the `NSAttributedString` containing the app credits using a delegate. This is great for making the about window play nice with Mojave's Dark Mode. Here's how it works:

```swift
@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate, StringPreprocessingProtocol {

	/// The window controller that handles the about window.
	private var _aboutWindowController: AboutWindowController?

	/// The window controller that handles the about window.
	private var aboutWindowController: AboutWindowController? {
		if self._aboutWindowController == nil {
			self._aboutWindowController = AboutWindowController.init()

			// Set the delegate
			self._aboutWindowController?.delegate = self
		}
		return self._aboutWindowController
	}


	//MARK: - StringPreprocessingProtocol

	/// Given the credits loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appCredits: <#appCredits description#>
	/// - Returns: <#description#>
	func preprocessAppCredits(_ appCredits: NSAttributedString?) -> NSAttributedString? {
		let credits: NSMutableAttributedString? = appCredits as? NSMutableAttributedString

		let attributes: [ NSAttributedString.Key : NSColor ] = [ NSAttributedString.Key.foregroundColor: NSColor.textColor ]
		let range: NSRange = NSRange.init(location: 0, length: credits?.length ?? 0)

		credits?.addAttributes(attributes, range: range)

		return credits
	}

	/// Given the acknowledgments loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appAcknowledgments: <#appAcknowledgments description#>
	/// - Returns: <#description#>
	func preprocessAppAcknowledgments(_ appAcknowledgments: NSAttributedString?) -> NSAttributedString? {
		let acknowledgments: NSMutableAttributedString? = appAcknowledgments as? NSMutableAttributedString

		let attributes: [ NSAttributedString.Key : NSColor ] = [ NSAttributedString.Key.foregroundColor: NSColor.textColor ]
		let range: NSRange = NSRange.init(location: 0, length: acknowledgments?.length ?? 0)

		acknowledgments?.addAttributes(attributes, range: range)

		return acknowledgments
	}
}
```

Thanks to [@balthisar](https://github.com/balthisar) for adding this.

# 3. Localization
Add the following lines to your Localizable.strings to change these values, or localize them.

```strings
// The string to be displayed in the label "appVersion" on InfoView.
"label_appVersion" = "v%1@ (%2@)";

// The string to be displayed in the button "visitWebsiteButton" on Window.
"buttonLabel_VisitWebsite" = "Visit the %1@ Website";

// The string to be displayed in the button "Acknowledgments" on Window.
"buttonLabel_Acknowledgments" = "Acknowledgments";

// The alternate string to be displayed in the button "Acknowledgments" on Window, when the variable value _useTextViewForAcknowledgments_ is true.
"buttonLabel_Credits" = "Credits";
```

# 4. Contributions and things to add
Be creative. AboutWindow should be a flexible, easy to use way to make the About Window for your app look pretty. Make sure your changes don't break existing functionality without good reason.

To create a pull request:

* Fork the repo;
* Create a new branch (`git checkout -b your-feature`);
* Add your code;
* Commit all your changes to your branch;
* Push it (`git push origin your-feature`);
* Submit a pull request via the GitHub web interface.

## 4.1. Spin-offs
Let me know if you made far going modifications by including your project in this section. Add yourself to the list and send me a pull request.

* [Your project on GitHub](http://www.dangercove.com) - A short description.

## 4.2. Add-ons
Related apps, tools and scripts that extend AboutWindow's functionality.

* [Acknowledge](https://github.com/DangerCove/Acknowledge) - Generates a single `Acknowledgments.rtf` from CocoaPods and custom markdown files.

# 5. License
New BSD License, see `LICENSE` for details.
