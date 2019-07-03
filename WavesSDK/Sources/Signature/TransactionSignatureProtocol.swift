//
//  TransactionSignatureProtocol.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

public protocol TransactionSignatureProtocol: SignatureProtocol {
    
    var version: Int { get }
    
    var type: TransactionType { get }
}

extension TransactionSignatureProtocol {

    public var typeByte: Int8 {
        return type.rawValue
    }
    
}
