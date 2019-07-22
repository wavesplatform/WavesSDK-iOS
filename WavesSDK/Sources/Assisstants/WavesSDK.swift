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
        
        
        var dataPlugins = servicesPlugins.data
        var nodePlugins = servicesPlugins.node
        var matcherPlugins = servicesPlugins.matcher
        
        dataPlugins.append(DebugServicePlugin())
        nodePlugins.append(DebugServicePlugin())
        matcherPlugins.append(DebugServicePlugin())
        
        let services = WavesServices(enviroment: enviroment,
                                     dataServicePlugins: dataPlugins,
                                     nodeServicePlugins: nodePlugins,
                                     matcherServicePlugins: matcherPlugins)
        
        WavesSDK.shared = WavesSDK(services: services, enviroment: enviroment)
    }
}

private final class DebugServicePlugin: PluginType {
    
    static var _userAgentDefault: String? = nil

    static let webView: UIWebView = UIWebView()
    
    static let serialQueue = DispatchQueue(label: "DebugServicePlugin")
    static let serialQueueWebView = DispatchQueue(label: "DebugServicePlugin.webView")
    
    static var userAgentDefault: String = {
        serialQueue.sync {
            if _userAgentDefault?.isEmpty ?? true {
                _userAgentDefault = DebugServicePlugin.webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")                
            }
            
            return _userAgentDefault ?? ""
        }
    }()
    
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        var mRq = request
        
        var userAgent = mRq.value(forHTTPHeaderField: "User-Agent") ?? ""
        
        if userAgent.isEmpty {
            userAgent = DebugServicePlugin.userAgentDefault
        }
        
        let bundle = Bundle.main.bundleIdentifier ?? ""
        
        userAgent = "\(userAgent) WavesSDK/\(WavesSDKVersionNumber) DeviceId/\(UIDevice.uuid) AppId/\(bundle)"
        
        mRq.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        return mRq
    }
    
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
    }
    
    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}
