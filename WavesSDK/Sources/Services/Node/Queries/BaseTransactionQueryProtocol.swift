//
//  BaseTransactionQueryProtocol.swift
//  WavesSDKExample
//
//  Created by rprokofev on 04.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

public protocol BaseTransactionQueryProtocol {
    /**
      ID of the transaction type. Correct values in [1; 16]
     */
    var type: Int { get }

    /**
      Version number of the data structure of the transaction.
      The value has to be equal to 1, 2 or 3
     */
    var version: Int { get }

    /**
     Determines the network where the transaction will be published to.
     T or 84 in bytes for test network,
     W or 87 in for main network
     */
    var chainId: UInt8 { get }

    /**
      A transaction fee is a fee that an account owner pays to send a transaction.
      Transaction fee in WAVELET
      [Wiki about Fee](https://docs.wavesplatform.com/en/blockchain/transaction-fee.html)
     */
    var fee: Int64 { get }

    /**
      Unix time of sending of transaction to blockchain, must be in current time +/- 1.5 hour
     */
    var timestamp: Int64 { get }

    /**
      Account public key of the sender in Base58
     */
    var senderPublicKey: String { get }

    /**
      Signatures v2 string set.
      A transaction signature is a digital signature
      with which the sender confirms the ownership of the outgoing transaction.
      If the array is empty, then S= 3. If the array is not empty,
      then S = 3 + 2 × N + (P1 + P2 + ... + Pn), where N is the number of proofs in the array,
      Pn is the size on N-th proof in bytes.
      The maximum number of proofs in the array is 8. The maximum size of each proof is 64 bytes
      */
    var proofs: [String] { get }
}
