//
//  TransactionLeaseNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 18.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension Node.DTO {
    struct LeaseTransaction: Decodable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64? //I do optional variable for cancel leasing model
        
        public let signature: String?
        public let proofs: [String]?
        public let amount: Int64
        public let recipient: String
    }
}
