//
//  SponsorshipTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 05/02/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      Sponsorship transaction (or is Autonomous Assets)
      moves Waves-fees for selected asset for all transfer transactions
      to your account.

      Sponsorship transaction is used to set a transaction fee nominated in an asset.
      However, node owners need to explicitly allow transaction fees in the asset
      by manually editing node configuration file.
      Otherwise, node won't be able to mine a block with these transactions.

      The sponsorship could be set for an asset. In this case miner will receive fee in waves
      for the processing of transactions, the fee of which is nominated in sponsored asset.

      After this transaction is confirmed, it becomes possible to use this asset
      as a fee (automatically for all miners). When transaction with fee in sponsored fee
      asset appears any miner just puts it to forged block.
      Instead of just transferring fee asset to miner's balance blockchain does a bit different thing:
      It automatically moves fee asset to sponsor's (issuer's) account
      and transfers standard transaction cost in WAVES from sponsor's to miner's accounts.
      In fact two miners will receive these WAVES because of NG 40/60 fee distributions.

      Example:
      I issue my own asset - Super Coin. I want others to use super coin as a fee.
      I create SponsorshipTransaction(asset="Super Coin's id", sponsored=true, transactionFee=0.1).
      Then I put 100 waves to my account. Now anyone can create Transfer transaction
      with 0.1 super coin as a fee. Someone creates transaction with fee = 0.1 super coin,
      as a result I get 0.1 super coin on my account, and miners get 0.001 waves from my account.
      Since I have 100 waves, users can do 100000 transaction until
      the deposit will be fully transferred to miners,
      at this moment I will have 10000 super coins from fees.
      When deposit is gone no new transactions with super coin fees can be made.

      Only the issuer of an asset can set up sponsorship.
      The sponsorship is set by giving the rate at which fee in an asset is converted to Waves.

      For cancel send with minSponsoredAssetFee == 0
     */
    struct SponsorshipTransaction: Codable {

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64?
        public let signature: String?
        public let proofs: [String]?
        public let version: Int
        /**
          Selected your asset Id for sponsorship
         */
        public let assetId: String
        /**
          Min sponsored asset fee. If "0" Sponsorship will be cancelled
         */
        public let minSponsoredAssetFee: Int64?
        public let applicationStatus: String?
    }
}
