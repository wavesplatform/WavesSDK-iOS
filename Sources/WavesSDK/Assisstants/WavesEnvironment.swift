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
    static let matcherUrlMainnet: URL = URL(string: "https://matcher.waves.exchange")!
    static let schemeMainnet: UInt8 = "W".utf8.first ?? 0
    
    static let dataUrlTestnet: URL = URL(string: "https://api-testnet.wavesplatform.com")!
    static let nodeUrlTestnet: URL = URL(string: "https://nodes-testnet.wavesnodes.com")!
    static let matcherUrlTestnet: URL = URL(string: "https://matcher-testnet.waves.exchange")!
    static let schemeTestnet: UInt8 = "T".utf8.first ?? 0
}

public struct WavesEnvironment {
    
    public enum Server {
        case mainNet
        case testNet
        case custom(node: URL, matcher: URL, data: URL, scheme: UInt8)
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
    
    public var chainId: UInt8!
    public var nodeUrl: URL
    public var matcherUrl: URL
    public var dataUrl: URL
    
  public init(server: Server = .testNet, timestampServerDiff: Int64 = 0) {
        
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
