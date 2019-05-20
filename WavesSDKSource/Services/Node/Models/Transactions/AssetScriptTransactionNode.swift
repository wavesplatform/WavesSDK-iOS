//
//  AssetScriptTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    struct AssetScriptTransaction: Decodable {

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64?
        public let signature: String?
        public let proofs: [String]?
        public let chainId: Int?
        public let assetId: String
        public let version: Int
        public let script: String?
    }
}
