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

struct AppInfo {
    private static let mainBundle = Bundle.main
    
    private static let versionKey = "CFBundleShortVersionString"
    // There's no constant for "CFBundleShortVersionString."
    static let version = mainBundle.object(forInfoDictionaryKey: versionKey) as! String
    
    private static let buildKey = kCFBundleVersionKey as String
    static let build = mainBundle.object(forInfoDictionaryKey: buildKey) as! String
}
