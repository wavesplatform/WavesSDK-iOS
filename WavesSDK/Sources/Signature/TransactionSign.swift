//
//  TransactionSigning.swift
//  WavesSDKExample
//
//  Created by rprokofev on 28.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import WavesSDKExtensions

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

extension NodeService.Query.Broadcast.Data.Value {

    var kindForSignatureV1Value: TransactionSignatureV1.Structure.Data.Value.Kind {
        switch self.value {
        case .binary(let value):
            return .binary(value)
            
        case .boolean(let value):
            return .boolean(value)
            
        case .integer(let value):
            return .integer(value)
            
        case .string(let value):
            return .string(value)
            
        }
    }
}

extension NodeService.Query.Broadcast.Data: TransactionSign {
    
    private static var DATA_TX_SIZE_WITHOUT_ENTRIES: Int = 52
    private static var DATA_ENTRIES_BYTE_LIMIT = 100 * 1024 - DATA_TX_SIZE_WITHOUT_ENTRIES
    
    public mutating func sign(privateKey: WavesSDKCrypto.PrivateKey?, seed: WavesSDKCrypto.Seed?, chainId: String) {
        
            
        let signature = TransactionSignatureV1.data(.init(fee: fee,
                                                          data: data.map { TransactionSignatureV1.Structure.Data.Value(key: $0.key,
                                                                                                                       value: $0.kindForSignatureV1Value) },
                                                          scheme: chainId,
                                                          senderPublicKey: senderPublicKey,
                                                          timestamp: timestamp))
        
        print("a - \(signature.bytesStructure.count) - max \(NodeService.Query.Broadcast.Data.DATA_ENTRIES_BYTE_LIMIT)")
        if signature.bytesStructure.count > NodeService.Query.Broadcast.Data.DATA_ENTRIES_BYTE_LIMIT {
            print("aasd")
            return
        }
        
            
        
        if let privateKey = privateKey, let proof: String = signature.signature(privateKey: privateKey) {
            proofs = [proof]
            
            let bytes: Bytes = (signature.signature(privateKey: privateKey))!
            print("b - \(bytes.count)")
            
        }
        
        if let seed = seed, let proof: String = signature.signature(seed: seed) {
            proofs = [proof]
            
            let bytes: Bytes = (signature.signature(seed: seed)!)
            print("b - \(bytes.count)")
            
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
