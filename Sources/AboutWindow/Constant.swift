import Foundation

/**
 * Global Constants
 - Author: ISHIKAWA Koutarou
 - Date: 2020/07/14
 - Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 */
struct Constant {
	/// <#Description#>
	static let k_APP_CACHE_FOLDER = ""
	//static let k_APP_CACHE_FOLDER = "com.stein2nd.AboutWindow/"

	//MARK: - Localizable.strings key

	/// Localizable.strings key. If the variable value _AboutWindowController.appWebsiteURL_ is nil, it is output as an error message.
	static let k_ERROR_appWebsiteUrlIsNil: String = "appWebsiteURL_is_nil"

	/// Localizable.strings key. If the variable value _AboutWindowController.acknowledgmentsPath_ is nil, it is output as an error message.
	static let k_ERROR_acknowledgmentsPathIsNil: String = "acknowledgmentsPath_is_nil"

	/// Localizable.strings key. The string to be displayed in the button "visitWebsiteButton" on Window.
	static let k_ButtonLabel_VisitWebsite: String = "buttonLabel_VisitWebsite"

	/// Localizable.strings key. The string to be displayed in the button "Acknowledgments" on Window.
	static let k_ButtonLabel_Acknowledgments: String = "buttonLabel_Acknowledgments"

	/// Localizable.strings key. The alternate string to be displayed in the button "Acknowledgments" on Window, when the variable value _useTextViewForAcknowledgments_ is true.
	static let k_ButtonLabel_Credits: String = "buttonLabel_Credits"

	/// Localizable.strings key. The string to be displayed in the label "appVersion" on InfoView.
	static let k_InfoView_Label_AppVersion: String = "label_appVersion"
}
