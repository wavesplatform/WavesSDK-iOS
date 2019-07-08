//
//  TransactionLeaseCancelNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      The Cancel leasing transaction reverse [LeaseTransaction].
      Lease cancel transaction is used to to cancel
      and discontinue the WAVES leasing process to a Waves node.
     */
    struct LeaseCancelTransaction: Decodable {
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
        public let chainId: Int?
        /**
          Id of Leasing Transaction to cancel
         */
        public let leaseId: String
        public let lease: NodeService.DTO.LeaseTransaction?
    }
}
