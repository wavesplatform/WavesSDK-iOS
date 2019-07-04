//
//  BaseTransactionQueryProtocol.swift
//  WavesSDKExample
//
//  Created by rprokofev on 04.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

public protocol BaseTransactionQueryProtocol {
    var type: Int { get }
    var version: Int { get }
    var chainId: String { get }
    var fee: Int64 { get }
    var timestamp: Int64 { get }
    var senderPublicKey: String { get }
    var proofs: [String] { get }
}
