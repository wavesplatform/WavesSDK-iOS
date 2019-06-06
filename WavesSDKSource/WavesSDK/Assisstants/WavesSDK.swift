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
    
    private var internalEnviroment: Enviroment
    
    public var enviroment: Enviroment {
        
        get {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            return internalEnviroment
        }
        
        set {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            internalEnviroment = newValue
            
            if var internalServices = services as? InternalWavesServiceProtocol {
                internalServices.enviroment = newValue
            }
        }
    }
    
    static private(set) public var shared: WavesSDK!
    
    init(services: WavesServicesProtocol, enviroment: Enviroment) {
        self.services = services
        self.internalEnviroment = enviroment
        
    }
    
    public class func isInitialized() -> Bool {
        return true
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
