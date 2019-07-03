//
//  TransactionMassTransferNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    struct MassTransferTransaction: Decodable {

        public struct Transfer: Decodable {
            public let recipient: String
            public let amount: Int64
        }

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64?

        public let proofs: [String]?
        public let assetId: String?
        public let attachment: String
        public let transferCount: Int
        public let totalAmount: Int64
        public let transfers: [Transfer]
    }
}
