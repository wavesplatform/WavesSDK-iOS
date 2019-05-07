//
//  UnrecognisedTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 31.08.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension Node.DTO {
    struct UnrecognisedTransaction: Decodable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64
    }
}
