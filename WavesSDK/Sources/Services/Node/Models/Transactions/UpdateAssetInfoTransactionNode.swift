//
//  TransactionIssueNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    struct UpdateAssetInfoTransaction: Codable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let feeAssetId: String?
        public let timestamp: Date
        public let version: Int
        public let height: Int64?
        public let chainId: UInt8?
        public let proofs: [String]?
        public let assetId: String

        /**
         Name of your new asset byte length must be in [4,16]
         */
        public let name: String

        /**
         Description of your new asset byte length must be in [0;1000]
         */
        public let description: String

        public let applicationStatus: String?
    }
}
