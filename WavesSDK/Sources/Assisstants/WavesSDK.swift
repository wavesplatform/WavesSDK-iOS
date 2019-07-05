/*
* ██╗    ██╗ █████╗ ██╗   ██╗███████╗███████╗
* ██║    ██║██╔══██╗██║   ██║██╔════╝██╔════╝
* ██║ █╗ ██║███████║██║   ██║█████╗  ███████╗
* ██║███╗██║██╔══██║╚██╗ ██╔╝██╔══╝  ╚════██║
* ╚███╔███╔╝██║  ██║ ╚████╔╝ ███████╗███████║
* ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝
*
* ██████╗ ██╗      █████╗ ████████╗███████╗ ██████╗ ██████╗ ███╗   ███╗
* ██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝██╔═══██╗██╔══██╗████╗ ████║
* ██████╔╝██║     ███████║   ██║   █████╗  ██║   ██║██████╔╝██╔████╔██║
* ██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║
* ██║     ███████╗██║  ██║   ██║   ██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║
* ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝
*
*/

import Foundation
import WavesSDKExtensions
import WavesSDKCrypto
import Moya

/**
 *
 * WavesSDK is library for easy and simple co-working Waves blockchain platform and app based on Rx.
 *
 * Library contains 3 parts:
 *
 * Waves Crypto – collection of functions to work with Waves basic types
 * and crypto primitives used by Waves.
 *
 * Waves Models – data transfer objects collection of transactions and other models
 * for work with Waves net services.
 * The models release signification with private key
 *
 * Waves Services – net-services for sending transactions and getting data from blockchain
 * and other Waves services
 */

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
        return WavesSDK.shared != nil
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
