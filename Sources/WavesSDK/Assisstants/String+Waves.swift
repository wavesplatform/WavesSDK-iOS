//
//  String+Waves.swift
//  Alamofire
//
//  Created by rprokofev on 21/05/2019.
//

import Foundation


public extension String {
    
    var normalizeWavesAssetId: String {
        if self == WavesSDKConstants.wavesAssetId {
            return ""
        } else {
            return self
        }
    }
    
    var normalizeToNullWavesAssetId: Any {
        
        let assetId = self.normalizeWavesAssetId
        
        if assetId.isEmpty {
            return NSNull()
        } else {
            return assetId
        }
    }
}
