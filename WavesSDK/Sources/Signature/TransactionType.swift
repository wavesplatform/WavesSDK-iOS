//
//  TransactionType.swift
//  WavesSDKExample
//
//  Created by rprokofev on 01.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

@frozen public enum TransactionType: Int8 {
    case issue = 3
    case transfer = 4
    case reissue = 5
    case burn = 6
    case exchange = 7
    case createLease = 8
    case cancelLease = 9
    case createAlias = 10
    case massTransfer = 11
    case data = 12
    case script = 13
    case sponsorship = 14
    case assetScript = 15
    case invokeScript = 16
    case updateAssetInfo = 17
    
    var int: Int {
        return Int(self.rawValue)
    }
}
