//
//  AppInfo.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 8/30/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//
//  Abstract:
//

import Foundation

/// The version and build numbers for this app.
struct AppInfo {
    /// The main bundle.
    private static let mainBundle = Bundle.main
    
    /// The key for the version number.
    ///
    /// The build-number key has a constant (`kCFBundleVersionKey`), but not the version-number key.
    private static let versionKey = "CFBundleShortVersionString"
    
    /// A `String` describing the version number.
    static let version = mainBundle.object(forInfoDictionaryKey: versionKey) as! String
    
    /// The key for the build number.
    private static let buildKey = kCFBundleVersionKey as String
        
    /// A `String` describing the build number.
    static let build = mainBundle.object(forInfoDictionaryKey: buildKey) as! String
}
