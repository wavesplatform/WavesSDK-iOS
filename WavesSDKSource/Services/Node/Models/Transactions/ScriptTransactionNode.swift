//
//  SetScriptTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension Node.DTO {

    struct ScriptTransaction: Decodable {

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
        public let version: Int
        public let script: String?
    }
}
