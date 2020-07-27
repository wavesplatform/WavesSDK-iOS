//
//  AssetScriptTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
     Set asset script transaction (set script to asset)

     You can only update script of asset, that was issued before by [IssueTransaction]

     An asset script is a script that is attached to an asset with a set asset script transaction.
     An asset with the attached script is called a smart asset.
     You can attach a script to an asset only during the creation of the asset.
     Script can be developed with [Waves Ride IDE]({https://ide.wavesplatform.com/)

     Smart assets are unique virtual currency tokens that may represent a tangible real-world asset,
     or a non-tangible ownership that can be purchased, sold, or exchanged as defined
     by the rules of a script on the Waves blockchain network.

     Only the issuer of that asset can change the asset's script.
     */
    struct SetAssetScriptTransaction: Codable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64?
        public let signature: String?
        public let proofs: [String]?
        public let chainId: UInt8?
        public let version: Int

        /**
         Selected for script asset Id
         */
        public let assetId: String

        /**
         Base64 binary string with Waves Ride script
         You can use "base64:compiledScriptStringInBase64" and just "compiledScriptStringInBase64".
         Can't be empty string
         */
        public let script: String?
        public let applicationStatus: String?
    }
}
