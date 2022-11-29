//
//  UnrecognisedTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 31.08.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    struct UnrecognisedTransaction: Codable {
        /**
          ID of the transaction type. Correct values in [1; 16]
         */
        public let type: Int
        public let id: String
        public let sender: String
        /**
          Account public key of the sender in Base58
         */
        public let senderPublicKey: String
        /**
          A transaction fee is a fee that an account owner pays to send a transaction.
          Transaction fee in WAVELET
         */
        public let fee: Int64
        /**
          Unix time of sending of transaction to blockchain, must be in current time +/- half of hour
         */
        public let timestamp: Date
        public let height: Int64
        public let applicationStatus: String?
    }
}
