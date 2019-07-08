//
//  Interface.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import WavesSDKExtensions

public protocol SignatureProtocol {
    
    var bytesStructure: WavesSDKCrypto.Bytes { get }
    
    func signature(privateKey: WavesSDKCrypto.PrivateKey) -> WavesSDKCrypto.Bytes?
    
    func signature(privateKey: WavesSDKCrypto.PrivateKey) -> String?
}

public extension SignatureProtocol {
    
    func signature(seed: Seed) -> WavesSDKCrypto.Bytes? {
        return WavesCrypto.shared.signBytes(bytes: bytesStructure, seed: seed)
    }
    
    func signature(seed: Seed) -> String? {
        guard let bytes: Bytes = signature(seed: seed) else { return nil }        
        return WavesCrypto.shared.base58encode(input: bytes)
    }
    
    func signature(privateKey: WavesSDKCrypto.PrivateKey) -> WavesSDKCrypto.Bytes? {
        return WavesCrypto.shared.signBytes(bytes: bytesStructure, privateKey: privateKey)
    }
    
    func signature(privateKey: WavesSDKCrypto.PrivateKey) -> String? {
        guard let bytes: Bytes = signature(privateKey: privateKey) else { return nil }
        return WavesCrypto.shared.base58encode(input: bytes)
    }
}
