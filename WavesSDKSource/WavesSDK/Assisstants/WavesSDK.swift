//
//  WavesSDK.swift
//  Alamofire
//
//  Created by rprokofev on 27/05/2019.
//

import Foundation
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
