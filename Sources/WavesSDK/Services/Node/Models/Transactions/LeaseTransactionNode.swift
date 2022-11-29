//
//  TransactionLeaseNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 18.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
      The Leasing transaction leases amount of Waves to node operator.
      it can be address or alias by Proof-of-Stake consensus. It will perform at non-node address.
      You always can reverse the any leased amount by [LeaseCancelTransaction]
     */
    struct LeaseTransaction: Codable {
        public let id: String
        public let originTransactionID: String?
        public let sender, recipient: String
        public let amount: Int64
        public let height: Int64?
        public let status: String?
        public let type: Int?
        public let senderPublicKey: String?
        public let fee: Int64?
        public let feeAssetID: String?
        public let timestamp: Date?
        public let proofs: [String]?
        public let version: Int?
    }

    struct LeaseResponse: Codable {
        public let id: String
        public let sender: String
        public let recipient: String
        public let amount: Int64
        public let height: Int64
        public var status: String?

        public init(
            id: String,
            sender: String,
            recipient: String,
            height: Int64,
            amount: Int64,            
            status: String?) {
            self.id = id
            self.sender = sender
            self.height = height
            self.amount = amount
            self.recipient = recipient
            self.status = status
        }
    }
}
