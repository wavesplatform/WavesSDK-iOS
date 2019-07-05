//
//  TransactionTransferNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      Transfer transaction sends amount of asset on address.
      It is used to transfer a specific amount of an asset (WAVES by default)
      to the recipient (by address or alias).
     */
    struct TransferTransaction: Decodable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64?

        public let signature: String?
        public let proofs: [String]?

        /**
          Address or alias of Waves blockchain
         */
        public let recipient: String

        /**
          Id of transferable asset in Waves blockchain, different for main and test net
         */
        public let assetId: String?

        /**
          Asset id instead Waves for transaction commission withdrawal
         */
        public let feeAssetId: String?

        /**
          Amount of asset in satoshi
         */
        public let amount: Int64

        /**
          Additional info [0,140] bytes of string
         */
        public let attachment: String?
    }
}
