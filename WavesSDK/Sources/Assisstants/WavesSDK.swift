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
import Moya
import WavesSDKCrypto
import WavesSDKExtensions
import WebKit

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

    public private(set) var services: WavesServicesProtocol

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

    public private(set) static var shared: WavesSDK!

    init(services: WavesServicesProtocol, enviroment: Enviroment) {
        self.services = services
        internalEnviroment = enviroment
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
    
    private var userAgent: String = ""

    private let webView: WKWebView
    
    private let backgroundQueueLock: NSLock
    private let backgroundQueue: DispatchQueue
    
    init() {
        webView = WKWebView()
        
        backgroundQueueLock = NSLock()
        backgroundQueue = DispatchQueue.global(qos: .userInteractive)
        
        backgroundQueue.async { [weak self] in
            self?.backgroundQueueLock.lock()
            self?.webView.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] result, error in
                if let userAgent = result as? String {
                    self?.userAgent = userAgent
                } else {
                    self?.userAgent = ""
                }
                self?.backgroundQueueLock.unlock()
            })
        }
    }

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var mRq = request

        let bundle = Bundle.main.bundleIdentifier ?? ""

        let requestUserAgent = "\(userAgent) WavesSDK/\(WavesSDKVersionNumber) DeviceId/\(UIDevice.uuid) AppId/\(bundle)"

        mRq.setValue(requestUserAgent, forHTTPHeaderField: "User-Agent")

        return mRq
    }

    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_: RequestType, target _: TargetType) {}

    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_: Result<Moya.Response, MoyaError>, target _: TargetType) {}

    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target _: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}
