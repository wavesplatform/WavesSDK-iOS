//
//  Enviroment.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation

private struct Constants {
    
    static let dataUrlMainnet: URL = URL(string: "https://api.wavesplatform.com")!
    static let nodeUrlMainnet: URL = URL(string: "https://nodes.wavesnodes.com")!
    static let matcherUrlMainnet: URL = URL(string: "https://matcher.wavesplatform.com")!
    static let schemeMainnet: String = "W"
    
    static let dataUrlTestnet: URL = URL(string: "https://api.testnet.wavesplatform.com")!
    static let nodeUrlTestnet: URL = URL(string: "https://pool.testnet.wavesnodes.com")!
    static let matcherUrlTestnet: URL = URL(string: "https://matcher.testnet.wavesnodes.com")!
    static let schemeTestnet: String = "T"
}

public struct Enviroment {
    
    public enum Server {
        case mainNet
        case testNet
        case custom(node: URL, matcher: URL, data: URL, scheme: String)
    }
    
    public var server: Server {
        
        didSet {
            switch server {
            case .custom(let node, let matcher, let data, let scheme):
                self.chainId = scheme
                self.dataUrl = data
                self.nodeUrl = node
                self.matcherUrl = matcher
                
            case .mainNet:
                self.chainId = Constants.schemeMainnet
                self.dataUrl = Constants.dataUrlMainnet
                self.nodeUrl = Constants.nodeUrlMainnet
                self.matcherUrl = Constants.matcherUrlMainnet
                
            case .testNet:
                self.chainId = Constants.schemeTestnet
                self.dataUrl = Constants.dataUrlTestnet
                self.nodeUrl = Constants.nodeUrlTestnet
                self.matcherUrl = Constants.matcherUrlTestnet
            }
        }
    }
    
    public var timestampServerDiff: Int64
    //TODO: Rename chainId
    public var chainId: String!
    
    public var nodeUrl: URL
    public var matcherUrl: URL
    public var dataUrl: URL
    
    public init(server: Server, timestampServerDiff: Int64) {
        
        self.server = server
        self.timestampServerDiff = timestampServerDiff
        
        switch server {
        case .custom(let node, let matcher, let data, let chainId):
            self.chainId = chainId
            self.dataUrl = data
            self.nodeUrl = node
            self.matcherUrl = matcher
            
        case .mainNet:
            self.chainId = Constants.schemeMainnet
            self.dataUrl = Constants.dataUrlMainnet
            self.nodeUrl = Constants.nodeUrlMainnet
            self.matcherUrl = Constants.matcherUrlMainnet
            
        case .testNet:
            self.chainId = Constants.schemeTestnet
            self.dataUrl = Constants.dataUrlTestnet
            self.nodeUrl = Constants.nodeUrlTestnet
            self.matcherUrl = Constants.matcherUrlTestnet        
        }
    }
}
