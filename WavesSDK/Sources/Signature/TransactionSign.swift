//
//  TransactionSigning.swift
//  WavesSDKExample
//
//  Created by rprokofev on 28.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto

public protocol TransactionSign {
    
    mutating func sign(seed: WavesSDKCrypto.Seed, chainId: String)
    
    mutating func sign(privateKey: WavesSDKCrypto.PrivateKey, chainId: String)
    
    mutating func sign(privateKey: WavesSDKCrypto.PrivateKey?, seed: WavesSDKCrypto.Seed?, chainId: String)
}

extension TransactionSign {
    
    public mutating func sign(seed: WavesSDKCrypto.Seed, chainId: String) {
        sign(privateKey: nil, seed: seed, chainId: chainId)
    }
    
    public mutating func sign(privateKey: WavesSDKCrypto.PrivateKey, chainId: String) {
        sign(privateKey: privateKey, seed: nil, chainId: chainId)
    }
}

extension NodeService.Query.Broadcast.Transfer: TransactionSign {
    
    public mutating func sign(privateKey: WavesSDKCrypto.PrivateKey?, seed: WavesSDKCrypto.Seed?, chainId: String) {
        
        let signature = TransactionSignatureV2.transfer(.init(senderPublicKey: senderPublicKey,
                                                              recipient: recipient,
                                                              assetId: assetId,
                                                              amount: amount,
                                                              fee: fee,
                                                              attachment: attachment,
                                                              feeAssetID: feeAssetId,
                                                              scheme: chainId,
                                                              timestamp: timestamp))
        
        if let privateKey = privateKey, let proof: String = signature.signature(privateKey: privateKey) {
            proofs = [proof]
        }
        
        if let seed = seed, let proof: String = signature.signature(seed: seed) {
            proofs = [proof]
        }
    }
}


//extension NodeService.Query.Broadcast.Transfer: TransactionSign {
//
//    public mutating func sign(privateKey: WavesSDKCrypto.PrivateKey?, seed: WavesSDKCrypto.Seed?, chainId: String) {
//
//        let signature = TransactionSignatureV2.transfer(.init(senderPublicKey: senderPublicKey,
//                                                              recipient: recipient,
//                                                              assetId: assetId,
//                                                              amount: amount,
//                                                              fee: fee,
//                                                              attachment: attachment,
//                                                              feeAssetID: feeAssetId,
//                                                              scheme: chainId,
//                                                              timestamp: timestamp))
//
//        if let privateKey = privateKey, let proof: String = signature.signature(privateKey: privateKey) {
//            proofs = [proof]
//        }
//
//        if let seed = seed, let proof: String = signature.signature(seed: seed) {
//            proofs = [proof]
//        }
//    }
//}



//case createAlias(Alias)
//case startLease(Lease)
//case cancelLease(LeaseCancel)
//case burn(Burn)
//case data(Data)

//extension NodeService.Query.Broadcast.Transfer: TransactionSign {
//
//    public mutating func sign(privateKey: WavesSDKCrypto.PrivateKey?, seed: WavesSDKCrypto.Seed?, chainId: String) {
//
//        let signature = TransactionSignatureV2.transfer(.init(senderPublicKey: senderPublicKey,
//                                                              recipient: recipient,
//                                                              assetId: assetId,
//                                                              amount: amount,
//                                                              fee: fee,
//                                                              attachment: attachment,
//                                                              feeAssetID: feeAssetId,
//                                                              scheme: chainId,
//                                                              timestamp: timestamp))
//
//        if let privateKey = privateKey, let proof: String = signature.signature(privateKey: privateKey) {
//            proofs = [proof]
//        }
//
//        if let seed = seed, let proof: String = signature.signature(seed: seed) {
//            proofs = [proof]
//        }
//    }
//}
