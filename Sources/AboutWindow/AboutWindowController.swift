import Foundation
import Cocoa
import SwiftTryCatch
import XCGLogger

/// The main logging class
public let log: XCGLogger? = {
	#if DEBUG

	/// The default XCGLogger object
	let log: XCGLogger = XCGLogger.default

	// get ~/Library/Caches
	let cacheDirectory: URL = {
		let urls: Array<URL> = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
		return urls[urls.endIndex - 1]
	}()

	//TODO: how to auto-rolling by date

	let logPath: URL? = cacheDirectory.appendingPathComponent("\(Constant.k_APP_CACHE_FOLDER)app.log")

	//log.setup(level: XCGLogger.Level.verbose, showLogIdentifier: true, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: XCGLogger.Level.debug)
	log.setup(level: XCGLogger.Level.verbose,
			  showLogIdentifier: true, showFunctionName: true, showThreadName: true,
			  showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true,
			  writeToFile: logPath, fileLevel: XCGLogger.Level.debug)

	return log

	#else

	return nil
	#endif
}()


/**
 The about window.
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Objective-C to Swift 5: 2020/07/10
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2014/01/20, Boy van Amstel
 - Original Copyright: © 2014 Danger Cove All rights reserved. This software is licensed under the BSD-3-Clause License. Full details can be found in the README.
 */
@objc public class AboutWindowController: NSWindowController {

	/// The delegate for the window controller.
	/// - Default: nil
	@objc public var delegate: Any?

	/// The URL pointing to the app's website.
	/// - Default: nil
	@objc public var appWebsiteURL: URL?

	/// The view that's currently active.
	@objc public var activeView: NSView?


	/// If set to true acknowledgments are shown in a text view, inside the window. Otherwise an external editor is launched.
	/// - Default: false
	@objc public var useTextViewForAcknowledgments: Bool = false


	/// The credits.
	/// - Default: contents of file at Bundle.main.path(forResource: "Credits", ofType: "rtf")
	@objc public var creditsString: NSAttributedString?

	/// The path to the file that contains the credits.
	private var _creditsPath: String?

	/// The path to the file that contains the credits.
	/// - Default: Bundle.main.path(forResource: "Credits", ofType: "rtf")
	@objc public var creditsPath: String? {
		get {
			self._creditsPath
		}
		set(newCreditsPath) {
			#if DEBUG
			log?.debug(String.init(format: "\n\t newCreditsPath: \(newCreditsPath ?? "")"))
			#endif

			self._creditsPath = newCreditsPath

			if newCreditsPath != nil {
				// Set credits
				let fileURL: URL = URL.init(fileURLWithPath: newCreditsPath ?? "")

				let options: [ NSAttributedString.DocumentReadingOptionKey : Any ] = [ NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf ]

				do {
					self.creditsString = try NSAttributedString.init(url: fileURL, options: options, documentAttributes: nil)
				} catch {
				}

				// Pre-process credits
				if let delegate: Any = self.delegate {
					if (delegate as AnyObject).responds(to: #selector(StringPreprocessingProtocol.preprocessAppCredits(_:))) {
						self.creditsString = (delegate as AnyObject).preprocessAppCredits(self.creditsString)
					}
				}
			}
		}
	}


	/// The string to hold the acknowledgments if we're showing them in same window.
	/// - Default: Bundle.main.path(forResource: "Acknowledgments", ofType: "rtf")
	@objc public var acknowledgmentsString: NSAttributedString?

	/// The path to the file that contains the acknowledgments.
	private var _acknowledgmentsPath: String?

	/// The path to the file that contains the acknowledgments.
	/// - Default: Bundle.main.path(forResource: "Acknowledgments", ofType: "rtf")
	@objc public var acknowledgmentsPath: String? {
		get {
			self._acknowledgmentsPath
		}
		set(newAcknowledgmentsPath) {
			#if DEBUG
			log?.debug(String.init(format: "\n\t newAcknowledgmentsPath: \(newAcknowledgmentsPath ?? "")"))
			#endif

			self._acknowledgmentsPath = newAcknowledgmentsPath

			if newAcknowledgmentsPath != nil {
				// Set acknowledgments
				let fileURL: URL = URL.init(fileURLWithPath: newAcknowledgmentsPath ?? "")

				let options: [ NSAttributedString.DocumentReadingOptionKey : Any ] = [ NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf ]

				do {
					self.acknowledgmentsString = try NSAttributedString.init(url: fileURL, options: options, documentAttributes: nil)
				} catch {
				}

				// Pre-process acknowledgments
				if let delegate: Any = self.delegate {
					if (delegate as AnyObject).responds(to: #selector(StringPreprocessingProtocol.preprocessAppAcknowledgments(_:))) {
						self.acknowledgmentsString = (delegate as AnyObject).preprocessAppAcknowledgments(self.acknowledgmentsString)
					}
				}
			} else {
				// Remove the button (and constraints)
				self.acknowledgmentsButton.removeFromSuperview()
			}
		}
	}


	//MARK: - IBOutlets

	/// The place holder view.
	@IBOutlet public var placeHolderView: NSView!

	/// The button that opens the app's website.
	@IBOutlet public var visitWebsiteButton: NSButton!

	/// The button that opens the acknowledgments.
	@IBOutlet public var acknowledgmentsButton: NSButton!

	/// The credits view.
	@IBOutlet public var creditsView: BackgroundView!

	/// The acknowledgments view.
	@IBOutlet public var acknowledgmentsView: BackgroundView!


	/// The application name.
	/// - Default: CFBundleName
	@IBOutlet weak var appNameLabel: NSTextField!

	/// The application version.
	/// - Default: "Version %1@ (Build %2@)", CFBundleVersion, CFBundleShortVersionString
	@IBOutlet weak var appVersionLabel: NSTextField!

	/// The credits text view.
	@IBOutlet public var creditsTextView: NSTextView!

	/// The copyright line.
	/// - Default: NSHumanReadableCopyright
	@IBOutlet weak var appCopyrightLabel: NSTextField!


	/// The acknowledgments text view.
	@IBOutlet public var acknowledgmentsTextView: NSTextView!


	//MARK: - NSObject

	/// Invoked by value(forKey:) when it finds no property corresponding to a given key.
	/// - Parameter key: A string that is not equal to the name of any of the receiver's properties.
	/// - Returns: <#description#>
	@objc public override func value(forUndefinedKey key: String) -> Any? {
		// this method was added by porter.
		log?.debug(String.init("\n\t Undefined key: \(key)"))

		return ""
	}


	//MARK: - IBActions

	/// Displays the window associated with the receiver.
	/// - Parameter sender: The control sending the message; can be nil.
	@IBAction public override func showWindow(_ sender: Any?) {
		#if DEBUG
		log?.debug(String.init(format: "\n\t sender: \(String(describing: sender))"))
		#endif

		super.showWindow(sender)

		SwiftTryCatch.try({
			// Show creditsView per default
			self.show(self.creditsView)

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}

	/// Visit the website.
	/// - Parameter sender: The object making the call.
	@IBAction public func visitWebsite(_ sender: Any) {
		#if DEBUG
		log?.debug(String.init(format: "\n\t sender: \(sender)"))
		#endif

		SwiftTryCatch.try({
			if self.appWebsiteURL != nil {
				if let appWebsiteURL: URL = self.appWebsiteURL {
					NSWorkspace.shared.open(appWebsiteURL)
				}
			} else {
				log?.debug(NSLocalizedString(Constant.k_ERROR_appWebsiteUrlIsNil, comment: ""))
			}

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}

	/// Show acknowledgments for libraries used etc.
	/// - Parameter sender: The object making the call.
	@IBAction public func showAcknowledgments(_ sender: Any) {
		#if DEBUG
		log?.debug(String.init(format: "\n\t sender: \(sender)"))
		#endif

		SwiftTryCatch.try({
			if self.useTextViewForAcknowledgments {
				var acknowledgmentsButtonLabel: String?

				// Toggle between the creditsView and the acknowledgmentsView
				if self.activeView?.isEqual(to: self.creditsView) ?? false {
					self.show(self.acknowledgmentsView)

					acknowledgmentsButtonLabel = NSLocalizedString(Constant.k_ButtonLabel_Credits, comment: "")
				} else {
					self.show(self.creditsView)

					acknowledgmentsButtonLabel = NSLocalizedString(Constant.k_ButtonLabel_Acknowledgments, comment: "Caption of the 'Acknowledgments' button in the about window")
				}

				self.acknowledgmentsButton.title = acknowledgmentsButtonLabel ?? ""

			} else {
				if self.acknowledgmentsPath != nil {
					// Load in default editor
					NSWorkspace.shared.openFile(self.acknowledgmentsPath ?? "")
				} else {
					log?.debug(NSLocalizedString(Constant.k_ERROR_acknowledgmentsPathIsNil, comment: ""))
				}
			}

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}


	//MARK: - NSWindowController

	/// <#Description#>
	/// - Parameter aDecoder: <#aDecoder description#>
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	/// Returns a window controller initialized with a given window.
	/// - Parameter aWindow: The window object to manage; can be nil.
	/// - Returns: A newly initialized window controller.
	override init(window aWindow: NSWindow?) {
		super.init(window: aWindow)
	}

	/// <#Description#>
	convenience init() {
		self.init(windowNibName: "AboutWindow")
	}

	/// Sent after the window owned by the receiver has been loaded.
	@objc public override func windowDidLoad() {
		super.windowDidLoad()

		SwiftTryCatch.try({
			// Load variables
			let bundleDict: NSDictionary? = Bundle.main.infoDictionary as NSDictionary?

			// app name
			let tempAppName: String? = bundleDict?.object(forKey: "CFBundleName") as? String
			#if DEBUG
			log?.debug(String.init(format: "\n\t tempAppName: \(tempAppName ?? "")"))
			#endif

			// app version
			let version: String? = bundleDict?.object(forKey: "CFBundleVersion") as? String
			let shortVersion: String? = bundleDict?.object(forKey: "CFBundleShortVersionString") as? String

			let tempAppVersion: String = String.init(format: NSLocalizedString(Constant.k_InfoView_Label_AppVersion, comment: "Version %1@ (Build %2@), displayed in the about window"), shortVersion ?? "", version ?? "")
			#if DEBUG
			log?.debug(String.init(format: "\n\t tempAppVersion: \(tempAppVersion)"))
			#endif

			// copyright
			let copyright: String? = bundleDict?.object(forKey: "NSHumanReadableCopyright") as? String
			#if DEBUG
			log?.debug(String.init(format: "\n\t copyright: \(copyright ?? "")"))
			#endif

			// Set app name
			self.appNameLabel.stringValue = tempAppName ?? ""
			
			// Set app version
			self.appVersionLabel.stringValue = tempAppVersion

			// Set copyright
			self.appCopyrightLabel.stringValue = copyright ?? ""


			// "visit website" caption
			let visitWebsiteButtonLabel: String = String.init(format: NSLocalizedString(Constant.k_ButtonLabel_VisitWebsite, comment: "Caption on the 'Visit the %1@ Website' button in the about window"), tempAppName ?? "")
			#if DEBUG
			log?.debug(String.init(format: "\n\t visitWebsiteButtonLabel: \(visitWebsiteButtonLabel)"))
			#endif

			// Set "visit website" caption
			self.visitWebsiteButton.title = visitWebsiteButtonLabel


			// the "acknowledgments" caption
			let acknowledgmentsButtonLabel: String = NSLocalizedString(Constant.k_ButtonLabel_Acknowledgments, comment: "Caption of the 'Acknowledgments' button in the about window")
			#if DEBUG
			log?.debug(String.init(format: "\n\t acknowledgmentsButtonLabel: \(acknowledgmentsButtonLabel)"))
			#endif

			// Set the "acknowledgments" caption
			self.acknowledgmentsButton.title = acknowledgmentsButtonLabel


			// acknowledgments
			let acknowledgmentsPathValue: String? = Bundle.main.path(forResource: "Acknowledgments", ofType: "rtf")
			#if DEBUG
			log?.debug(String.init(format: "\n\t acknowledgmentsPathValue: \(acknowledgmentsPathValue ?? "")"))
			#endif

			// Set acknowledgments
			self.acknowledgmentsString = nil
			self.acknowledgmentsPath = acknowledgmentsPathValue
			#if DEBUG
			log?.debug(String.init(format: "\n\t acknowledgmentsPath: \(self.acknowledgmentsPath ?? "")"))
			#endif
			if let filePath: String = self.acknowledgmentsPath {
				self.acknowledgmentsTextView.readRTFD(fromFile: filePath)
			}
			// Disable editing
			self.acknowledgmentsTextView.isEditable = false // Somehow IB checkboxes are not working


			// credits
			let creditsPathValue: String? = Bundle.main.path(forResource: "Credits", ofType: "rtf")
			#if DEBUG
			log?.debug(String.init(format: "\n\t creditsPathValue: \(creditsPathValue ?? "")"))
			#endif

			// Set credits
			self.creditsString = nil
			self.creditsPath = creditsPathValue
			#if DEBUG
			log?.debug(String.init(format: "\n\t creditsPath: \(self.creditsPath ?? "")"))
			#endif
			if let filePath: String = self.creditsPath {
				self.creditsTextView.readRTFD(fromFile: filePath)
			}
			// Disable editing
			self.creditsTextView.isEditable = false // Somehow IB checkboxes are not working

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}


	//MARK: -

	/// <#Description#>
	/// - Parameter theView: <#theView description#>
	@objc public func show(_ theView: BackgroundView?) {
		#if DEBUG
		log?.debug(String.init(format: "\n\t theView: \(String(describing: theView))"))
		#endif

		// Exit early if the view is the same
		if theView?.isEqual(to: self.activeView) ?? false {
			return
		}

		SwiftTryCatch.try({
			// Remove the active view from the place holder
			if self.activeView != nil {
				self.activeView?.removeFromSuperview()
			}

			// Resize view to fit
			theView?.autoresizingMask = [ NSView.AutoresizingMask.height, NSView.AutoresizingMask.width ]
			theView?.frame = self.placeHolderView.bounds

			// Add to placeholder
			if let theView: BackgroundView = theView {
				self.placeHolderView.addSubview(theView)
			}

			// Set colors
			theView?.backgroundColor = NSColor.textBackgroundColor
			theView?.trimColor = NSColor.windowFrameColor

			// Set active view
			self.activeView = theView

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}
}
