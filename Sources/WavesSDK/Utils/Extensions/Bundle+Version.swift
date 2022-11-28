//
//  Bundle+Version.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 11/10/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import CwlUtils
import Foundation
import CoreTelephony

private struct DeviceIdStorage: TSUD {
    
    private static let key: String = "com.waves.device.id"
    
    static var defaultValue: String? {
        return nil
    }
    
    static var stringKey: String {
        return DeviceIdStorage.key
    }
}

public struct WavesDevice {

    var osVersion: String {
        get {
          Sysctl.version
        }
    }

    var appVersion: String {
        get {
            return Bundle.main.version
        }
    }

    var deviceModel: String {
        get {
          Sysctl.model
        }
    }

    var language: String {
        get {
            return NSLocale.preferredLanguages.first ?? ""
        }
    }
    
    public static var uuid: String {
        
        if let id = DeviceIdStorage.value {
            return id
        } else {
            let id = UUID().uuidString
            DeviceIdStorage.value = id
            return id
        }
    }

    func deviceDescription() -> String {
        return "\n\n\n\n---Device Info---" +
            "\nOS Version: \(osVersion)" +
            "\nApp Version: \(appVersion)" +
            "\nDevice Model: \(deviceModel)" +
            "\nLanguage: \(language)"
    }
}

public extension Bundle {
    
    var version: String {
        let dictionary = Bundle.main.infoDictionary!
        return (dictionary["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    var build: String {
        
        let dictionary = Bundle.main.infoDictionary!
        let build = (dictionary["CFBundleVersion"] as? String) ?? ""
        
        return "\(build)"
    }
    
    var versionAndBuild: String {
        
        let dictionary = Bundle.main.infoDictionary!
        let version = (dictionary["CFBundleShortVersionString"] as? String) ?? ""
        let build = (dictionary["CFBundleVersion"] as? String) ?? ""
        
        return "\(version) (\(build))"
    }
}


