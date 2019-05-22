//
//  String+Waves.swift
//  Alamofire
//
//  Created by rprokofev on 21/05/2019.
//

import Foundation
import WavesSDKExtension

extension String {
    
    var normalizeWavesAssetId: String {
        if self == WavesSDKCryptoConstants.wavesAssetId {
            return ""
        } else {
            return self
        }
    }
}
