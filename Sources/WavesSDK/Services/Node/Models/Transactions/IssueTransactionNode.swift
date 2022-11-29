//
//  TransactionIssueNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
     The Issue transaction add a new asset in blockchain.

     Issue transaction is used to give the user the possibility to issue his/her own tokens
     on Waves blockchain. The user can define the exact amount of the issued tokens
     and he can reissue more tokens later by enabling the reissuable flag (1- true).

     Script can be developed with [Waves Ride IDE]({https://ide.wavesplatform.com/)
     */
    struct IssueTransaction: Codable {
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
        public let assetId: String

        /**
         Name of your new asset byte length must be in [4,16]
         */
        public let name: String

        /**
         Quantity defines the total tokens supply that your asset will contain.
         */
        public let quantity: Int64

        /**
         Reissuability allows for additional tokens creation that will be added
         to the total token supply of asset.
         A non-reissuable asset will be permanently limited to the total token supply
         defined during the transaction.
         */
        public let reissuable: Bool

        /**
         Decimals defines the number of decimals that your asset token will be divided in.
         Max decimals is 8
         */
        public let decimals: Int

        /**
         Description of your new asset byte length must be in [0;1000]
         */
        public let description: String

        /**
         A Smart Asset is an asset with an attached script that places conditions
         on every transaction made for the token in question.
         Each validation of a transaction by a Smart Asset's script increases the transaction fee
         by 0.004 WAVES. For example,

         if a regular tx is made for a Smart Asset, the cost is 0.001 + 0.004 = 0.005 WAVES.
         If an exchange transaction is made, the cost is 0.003 + 0.004 = 0.007 WAVES.

         Null - issue without script.

         You can update it later only if here in issue script != null.
         You can't update later if set script == null now

         You can use "base64:compiledScriptStringInBase64" and just "compiledScriptStringInBase64"
         Can't be empty string
         */
        public let script: String?

        public let applicationStatus: String?
    }
}
