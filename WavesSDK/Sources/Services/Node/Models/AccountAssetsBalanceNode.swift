//
//  AssetBalanceNodeService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    struct AddressAssetBalance: Decodable {
        public let address: String
        public let assetId: String
        public let balance: Int64
    }

    struct AddressAssetsBalance: Decodable {
        public let address: String
        public let balances: [AssetBalance]
    }

    struct AssetBalance: Decodable {

        public struct IssueTransaction: Decodable {
            public let type: Int64
            public let id: String
            public let sender: String
            public let senderPublicKey: String
            public let fee: Int64
            public let timestamp: Date
            public let signature: String?
            public let proofs: [String]?
            public let version: Int64
            public let assetId: String
            public let name: String
            public let quantity: Int64
            public let reissuable: Bool
            public let decimals: Int64
            public let description: String
            public let script: String?
        }
        
        public let assetId: String
        public let balance: Int64
        public let reissuable: Bool
        public let minSponsoredAssetFee: Int64?
        public let sponsorBalance: Int64?
        public let quantity: Int64
        public let issueTransaction: IssueTransaction?
    }
}
