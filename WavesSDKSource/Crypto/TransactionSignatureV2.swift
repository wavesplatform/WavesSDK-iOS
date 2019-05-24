//
//  TransactionSignature.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import WavesSDKExtension

enum TransactionType: Int8 {
    case issue = 3
    case transfer = 4
    case reissue = 5
    case burn = 6
    case exchange = 7
    case lease = 8
    case leaseCancel = 9
    case alias = 10
    case massTransfer = 11
    case data = 12
    case script = 13
    case sponsorship = 14
    case assetScript = 15
    case invokeScript = 16
}

public extension TransactionSignatureV2 {
    
    struct Alias {
        let alias: String
        let fee: Int64
    }
    
    struct Lease {
        let recipient: String
        let amount: Int64
        let fee: Int64
    }
    
    struct Burn {
        let assetID: String
        let quantity: Int64
        let fee: Int64
    }
    
    struct CancelLease {
        let leaseId: String
        let fee: Int64
    }
    
    struct Data {
        public struct Value {
            public enum Kind {
                case integer(Int64)
                case boolean(Bool)
                case string(String)
                case binary([UInt8])
            }
            
            let key: String
            let value: Kind
        }
        
        let fee: Int64
        let data: [Value]
    }
    
    struct Transfer {
        let senderPublicKey: String
        let recipient: String
        let assetId: String
        let amount: Int64
        let fee: Int64
        let attachment: String
        let feeAssetID: String
        let scheme: String
        let timestamp: Int64
    }
}

public enum TransactionSignatureV2: TransactionSignatureProtocol {
    
    case createAlias(Alias)
    case lease(Lease)
    case burn(Burn)
    case cancelLease(CancelLease)
    case data(Data)
    case transfer(Transfer)
    
    var version: Int {
        return 2
    }
}

public extension TransactionSignatureV2 {
    
    var bytesOrder: WavesSDKCrypto.Bytes {
        
        switch self {
        case .createAlias(let model):
            return []
            
        case .lease(let model):
            return []
            
        case .burn(let model):
            return []
            
        case .cancelLease(let model):
            return []
            
        case .data(let model):
            return []
            
        case .transfer(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKCryptoConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += model.scheme.utf8
                recipient += model.recipient.arrayWithSize()
            } else {
                recipient += WavesCrypto.shared.base58decode(input: model.recipient) ?? []
            }
            
            var signature: [UInt8] = []
            signature += toByteArray(Int8(TransactionType.transfer.rawValue))
            signature += toByteArray(Int8(self.version))
            signature += (WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? [])
            signature += model.assetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: model.assetId) ?? []))
            signature += model.feeAssetID.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: model.feeAssetID) ?? []))
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.amount)
            signature += toByteArray(model.fee)
            signature += recipient
            signature += model.attachment.arrayWithSize()
            
        default:
            return []
        }
        
        return []
    }
}
