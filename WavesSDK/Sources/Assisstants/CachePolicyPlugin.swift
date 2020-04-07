//
//  CachePolicyPlugin.swift
//  WavesSDK
//
//  Created by rprokofev on 07.04.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation
import Moya

public protocol CachePolicyTarget {
    var cachePolicy: URLRequest.CachePolicy { get }
}

public final class CachePolicyPlugin: PluginType {
    
    public init() { }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        if let cachePolicyGettable = target as? CachePolicyTarget {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        
        return request
    }
}
