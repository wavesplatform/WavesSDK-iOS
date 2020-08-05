//
//  TransactionReissueNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      The Reissue transaction is used to give the ability to reissue more tokens of an asset
      by specifying the amount and the asset id. Only quantity and reissuable can be new values
     */
    struct ReissueTransaction: Codable {
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
        public let chainId: UInt8?

        /**
          Id of asset that should be changed
         */
        public let assetId: String
        /**
          Quantity defines the total tokens supply that your asset will contain
         */
        public let quantity: Int64
        /**
          Reissuability allows for additional tokens creation that will be added
          to the total token supply of asset.
          A non-reissuable asset will be permanently limited to the total token supply
          defined during the transaction.
         */
        public let reissuable: Bool
        public let applicationStatus: String?
    }
}
