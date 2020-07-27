import Foundation

/**
 When AboutWindow loads resources from the bundle, these delegate methods will be called, enabling pre-processing of text prior to display. Potential applications include:
 - Re-coloring an NSAttributedString with named colors, because RTF only supports hard-coded colors. This enables automatic support for different appearances, such as Dark Mode in macOS 10.14+.
 - String substitution, for example, for displaying framework version information in the text in the about window.

 - Migrator: ISHIKAWA Koutarou
 - Migrated from Objective-C to Swift 5: 2020/07/10
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2014/01/20, Boy van Amstel
 - Original Copyright: © 2014 Danger Cove All rights reserved. This software is licensed under the BSD-3-Clause License. Full details can be found in the README.
 */
@objc public protocol StringPreprocessingProtocol: AnyObject {

	/// Given the credits loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appCredits: The credits. Default: contents of file at Bundle.main.path(forResource: “Credits”, ofType: “rtf”)
	func preprocessAppCredits(_ appCredits: NSAttributedString?) -> NSAttributedString?

	/// Given the acknowledgments loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appAcknowledgments: The string to hold the acknowledgments if we’re showing them in same window. Default: Bundle.main.path(forResource: “Acknowledgments”, ofType: “rtf”)
	func preprocessAppAcknowledgments(_ appAcknowledgments: NSAttributedString?) -> NSAttributedString?
}
