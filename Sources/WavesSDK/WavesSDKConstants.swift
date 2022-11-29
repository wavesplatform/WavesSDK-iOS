//
//  GlobalConstants.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 16/10/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation


public enum WavesSDKConstants {
    public static let aliasNameMinLimitSymbols: Int = 4
    public static let aliasNameMaxLimitSymbols: Int = 30
    public static let wavesAssetId = "WAVES"
    public static let WavesTransactionFeeAmount: Int64 = 100000
    public static let WavesDecimals: Int = 8
    public static let FiatDecimals: Int = 2
    //public static let appstoreURL: URL = URL(string: "https://apps.apple.com/ua/app/id1233158971")!

    public enum UrlScheme {
        #if DEBUG
        static let wallet: String = "waves-dev"
        #elseif TEST
        static let wallet: String = "waves-test"
        #else
        static let wallet: String = "waves"
        #endif
    }
}

public enum RegEx {
    static let alias = "^[a-z0-9\\.@_-]*$"

    public static func alias(_ alias: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: RegEx.alias)
            return regex.matches(in: alias, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange(location: 0, length: alias.count)).count > 0
        } catch let e {
            SweetLogger.error(e)
            return false
        }
    }
}
