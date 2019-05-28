//
//  WavesSDK.swift
//  Alamofire
//
//  Created by rprokofev on 27/05/2019.
//

import Foundation

//
//protocol AddressService {}
//
//
//protocol WavesServices {
//
//    var addressService: AddressService { get }
//
//    var serverKind: ServerKind { get set }
//}
//
//protocol WavesCrypto {
//    //Interface Юрки
//}
//


public struct Enviroment {
    
    public enum Server {
        case mainNet
        case testNet
        case custom(node: URL, matcher: URL, data: URL, scheme: String)
    }
    
    public let server: Server
    public let timestampServerDiff: Int64
    public let scheme: String
    
    public let nodeUrl: URL
    public let matcherUrl: URL
    public let dataUrl: URL
    
    public init(server: Server, timestampServerDiff: Int64) {
        
        self.server = server
        self.timestampServerDiff = timestampServerDiff
        
        switch server {
        case .custom(let node, let matcher, let data, let scheme):
            self.scheme = scheme
            self.dataUrl = data
            self.nodeUrl = node
            self.matcherUrl = matcher
            
        case .mainNet:
            self.scheme = "W"
            self.dataUrl = URL(string: "https://api.wavesplatform.com")!
            self.nodeUrl = URL(string: "https://nodes.wavesnodes.com")!
            self.matcherUrl = URL(string: "https://matcher.wavesplatform.com")!
            
        case .testNet:
            self.scheme = "T"
            self.dataUrl = URL(string: "https://api.testnet.wavesplatform.com")!
            self.nodeUrl = URL(string: "https://pool.testnet.wavesnodes.com")!
            self.matcherUrl = URL(string: "https://matcher.testnet.wavesnodes.com")!
        }
    }
}

import WavesSDKExtension
import WavesSDKCrypto
import Moya

public final class WavesSDK {
    
    public struct ServicesPlugins {
        public let data: [PluginType]
        public let node: [PluginType]
        public let matcher: [PluginType]

        public init(data: [PluginType], node: [PluginType], matcher: [PluginType]) {
            self.data = data
            self.node = node
            self.matcher = matcher
        }
    }
    
    private(set) public var services: WavesServicesProtocol
    public let crypto: WavesCrypto = WavesCrypto.shared
    public let enviroment: Enviroment
    
    static private(set) public var shared: WavesSDK!
    
    init(services: WavesServicesProtocol, enviroment: Enviroment) {
        self.services = services
        self.enviroment = enviroment
    }
    
    public class func initialization(servicesPlugins: ServicesPlugins,
                                     enviroment: Enviroment) {
        
        let services = WavesServices(enviroment: enviroment,
                                     dataServicePlugins: servicesPlugins.data,
                                     nodeServicePlugins: servicesPlugins.node,
                                     matcherServicePlugins: servicesPlugins.matcher)
        
        WavesSDK.shared = WavesSDK(services: services, enviroment: enviroment)
    }
}
