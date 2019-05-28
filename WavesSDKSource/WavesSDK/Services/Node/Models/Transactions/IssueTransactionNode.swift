//
//  TransactionIssueNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    struct IssueTransaction: Decodable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64
        
        public let signature: String?
        public let proofs: [String]?
        public let assetId: String
        public let name: String
        public let quantity: Int64
        public let reissuable: Bool
        public let decimals: Int
        public let description: String
        public let script: String?
    }
}
