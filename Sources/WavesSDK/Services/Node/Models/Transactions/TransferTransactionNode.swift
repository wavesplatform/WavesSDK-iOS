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
    struct TransferTransaction: Codable {
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

        public let applicationStatus: String?

        public init(
            type: Int,
            id: String,
            sender: String,
            senderPublicKey: String,
            fee: Int64,
            timestamp: Date,
            version: Int,
            height: Int64?,
            signature: String?,
            proofs: [String]?,
            recipient: String,
            assetId: String?,
            feeAssetId: String?,
            amount: Int64,
            attachment: String?,
            applicationStatus: String?) {
            self.type = type
            self.id = id
            self.sender = sender
            self.senderPublicKey = senderPublicKey
            self.fee = fee
            self.timestamp = timestamp
            self.version = version
            self.height = height
            self.signature = signature
            self.proofs = proofs
            self.recipient = recipient
            self.assetId = assetId
            self.feeAssetId = feeAssetId
            self.amount = amount
            self.attachment = attachment
            self.applicationStatus = applicationStatus
        }
    }
}
