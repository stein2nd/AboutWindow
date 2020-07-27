import Foundation
import Cocoa
import SwiftTryCatch
import XCGLogger

/**
 The background view.
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Objective-C to Swift 5: 2020/07/10
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2018/08/29, Jim Derry
 - Original Copyright: © 2018 Jim Derry All rights reserved. This software is licensed under the BSD-3-Clause License. Full details can be found in the README.
 */
@objc public class BackgroundView: NSView {

	/// The view's background color.
	private var _backgroundColor: NSColor?

	///  The view's trim color.
	private var _trimColor: NSColor?

	@objc public var bottomBorder: CALayer?

	/// The view's background color.
	/// - Remark: Default: NSColor.textBackgroundColor
	@objc public var backgroundColor: NSColor? {
		get {
			if self._backgroundColor == nil {
				self._backgroundColor = NSColor.textBackgroundColor
			}

			return self._backgroundColor ?? NSColor.clear
		}
		set(newBackgroundColor) {
			#if DEBUG
			log?.debug(String.init(format: "\n\t newBackgroundColor: \(String(describing: newBackgroundColor))"))
			#endif

			self._backgroundColor = newBackgroundColor
		}
	}

	/// The view's trim color.
	/// - Remark: Default: NSColor.windowFrameColor
	@objc public var trimColor: NSColor? {
		get {
			if self._trimColor == nil {
				self._trimColor = NSColor.windowFrameColor
			}

			return self._trimColor ?? NSColor.clear
		}
		set(newTrimColor) {
			#if DEBUG
			log?.debug(String.init(format: "\n\t newTrimColor: \(String(describing: newTrimColor))"))
			#endif

			self._trimColor = newTrimColor
		}
	}


	//MARK: - NSObject

	/// Invoked by value(forKey:) when it finds no property corresponding to a given key.
	/// - Parameter key: A string that is not equal to the name of any of the receiver's properties.
	/// - Returns: <#description#>
	@objc public override func value(forUndefinedKey key: String) -> Any? {
		// this method was added by porter.
		log?.debug(String.init("\n\t Undefined key: \(key)"))

		return ""
	}


	//MARK: - NSView

	/// Initializes and returns a newly allocated NSView object with a specified frame rectangle.
	/// - Parameter frameRect: The frame rectangle for the created view object.
	/// - Returns: An initialized NSView object or nil if the object couldn't be created.
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		self.wantsLayer = true

		// Add bottom border
		self.bottomBorder = CALayer.init()
		self.bottomBorder?.borderWidth = 1
		self.bottomBorder?.frame = CGRect.init(x: -1.0, y: 0.0,
											   width: frame.width + 2.0, height: frame.height + 1.0)
		
		bottomBorder?.autoresizingMask = [ CAAutoresizingMask.layerHeightSizable, CAAutoresizingMask.layerWidthSizable ]

		if let bottomBorder: CALayer = self.bottomBorder {
			self.layer?.addSublayer(bottomBorder)
		}
	}

	/// Updates the view’s content by modifying its underlying layer.
	@objc public override func updateLayer() {
		SwiftTryCatch.try({
			// Update with new color definitions.
			self.layer?.backgroundColor = self.backgroundColor?.cgColor
			self.bottomBorder?.borderColor = self.trimColor?.cgColor

		}, catch: {exception in
			log?.debug()
		}, finallyBlock: {
		})
	}


	//MARK: - NSResponder

	/// <#Description#>
	/// - Parameter aDecoder: <#aDecoder description#>
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
