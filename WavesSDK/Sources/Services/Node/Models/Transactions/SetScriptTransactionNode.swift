//
//  SetScriptTransactionNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      Script transactions (set script to account) allow you to extend the available functionality
      of the standard Waves application. One of the uses of script transaction
      is creating a multi-signature wallet. Script can be developed
      with [Waves Ride IDE]({https://ide.wavesplatform.com/)

      An account with the attached script is called a smart account.

      You can also cancel the active script transaction. You must send transaction with null script.

      Before you start, please keep in mind.
      We do not recommend you submit script transactions unless you are an experienced user.

      !!! Errors can lead to permanent loss of access to your account.

      Set script transaction is used to setup an smart account,
      The account needs to issue Set script transaction which contains the predicate.
      Upon success, every outgoing transaction will be validated not by the default mechanism
      of signature validation, but according to the predicate logic.

      Account script can be changed or cleared if the script installed allows
      the new set script transaction to process. The set script transaction can be changed
      by another set script transaction call unless it’s prohibited by a previous set script.
     */
    struct SetScriptTransaction: Codable {

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
          Base64 binary string with Waves Ride script
          Null for cancel script. Watch out about commissions on set and cancel script
          You can use "base64:compiledScriptStringInBase64" and just "compiledScriptStringInBase64".
          Can't be empty string
         */
        public let script: String?
        public let applicationStatus: String?
    }
}
