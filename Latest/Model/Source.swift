//
//  Source.swift
//  Latest
//
//  Created by Max Langer on 14.03.22.
//  Copyright © 2022 Max Langer. All rights reserved.
//

import AppKit

extension App {
	
	/// The source of update information.
	enum Source: String, Equatable {
		/// No known source had information about this app. It is unsupported by the update checker.
		case none
		
		/// The Sparkle Updater is the update source.
		case sparkle
		
		/// The Mac App Store is the update source.
		case appStore
		
		/// Homebrew is the update source.
		case homebrew
		
		/// The icon representing the source.
		var sourceIcon: NSImage? {
			switch self {
			case .none:
				return nil
			case .sparkle:
				return NSImage(named: "sparkle")
			case .appStore:
				return NSImage(named: "appstore") ?? Self.appStoreAppIcon
			case .homebrew:
				return NSImage(named: "brew") ?? Self.homebrewBadge
			}
		}
		
		/// Whether the source is marked with its icon in the list of apps. Sparkle is the common case and stays unmarked.
		var isBadgedInList: Bool {
			switch self {
			case .appStore, .homebrew:
				return true
			case .none, .sparkle:
				return false
			}
		}
		
		/// The App Store app's own icon. Used when the asset catalog has no "appstore" image.
		private static let appStoreAppIcon: NSImage? = {
			let path = "/System/Applications/App Store.app"
			guard FileManager.default.fileExists(atPath: path) else { return nil }
			return NSWorkspace.shared.icon(forFile: path)
		}()
		
		/// Homebrew's beer mug, drawn as a small image. Used when the asset catalog has no "brew" image.
		private static let homebrewBadge = NSImage(size: NSSize(width: 16, height: 16), flipped: false) { rect in
			let text = NSAttributedString(string: "🍺", attributes: [.font: NSFont.systemFont(ofSize: 13)])
			let size = text.size()
			text.draw(at: NSPoint(x: (rect.width - size.width) / 2, y: (rect.height - size.height) / 2))
			return true
		}
		
		/// The name of the source.
		var sourceName: String? {
			switch self {
			case .none:
				return nil
			case .sparkle:
				return NSLocalizedString("WebSource", comment: "The source name for apps loaded from third-party websites.")
			case .appStore:
				return NSLocalizedString("AppStoreSource", comment: "The source name of apps loaded from the App Store.")
			case .homebrew:
				return NSLocalizedString("HomebrewSource", comment: "The source name for apps checked via the Homebrew package manager.")
				
			}
		}
	}
}

// MARK: - Support State

extension App.Source {
	/// Possible states for whether a source is supported by the app.
	enum SupportState {
		/// The source is fully supported, including in-app updates.
		case full
		
		/// There is some update information available, but it may be incomplete. In-app updates do not work.
		case limited
		
		/// The source is unknown and no update information is available.
		case none
	}
	
	/// Whether the source is supported by the app.
	var supportState: SupportState {
		switch self {
		case .none:
			return .none
		case .sparkle, .appStore:
			return .full
		case .homebrew:
			return .limited
		}
	}
}


// MARK: Accessors

extension App.Source.SupportState {
	/// Returns an image using the system status indicator (colored dot) for the given status.
	var statusImage: NSImage {
		let name = switch self {
		case .full: NSImage.statusAvailableName
		case .limited: NSImage.statusPartiallyAvailableName
		case .none: NSImage.statusUnavailableName
		}
		
		return NSImage(named: name)!
	}
	
	/// Returns a label briefly describing the given status.
	var label: String {
		switch self {
		case .full: NSLocalizedString("SupportedLabel", comment: "A label used for apps which are fully supported by Latest.")
		case .limited: NSLocalizedString("LimitedSupportLabel", comment: "A label used for apps which are partially supported by Latest.")
		case .none: NSLocalizedString("UnsupportedLabel", comment: "A label used for apps which are not supported by Latest.")
		}
	}
	
	/// A more compact version of the label describing the given status.
	var compactLabel: String {
		switch self {
		case .full: NSLocalizedString("SupportedCompactLabel", comment: "A compact label used for apps which are fully supported by Latest.")
		case .limited: NSLocalizedString("LimitedSupportCompactLabel", comment: "A compact label used for apps which are partially supported by Latest.")
		case .none: NSLocalizedString("UnsupportedCompactLabel", comment: "A compact label used for apps which are not supported by Latest.")
		}
	}
}
