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

    private var internalEnviroment: WavesEnvironment

    public var enviroment: WavesEnvironment {
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

    init(services: WavesServicesProtocol, enviroment: WavesEnvironment) {
        self.services = services
        internalEnviroment = enviroment
    }

    public class func isInitialized() -> Bool {
        return WavesSDK.shared != nil
    }

    public class func initialization(servicesPlugins: ServicesPlugins,
                                     enviroment: WavesEnvironment) {
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

    private var webView: WKWebView?

    static let serialQueue = DispatchQueue(label: "DebugServicePlugin")
    static let serialQueueWebView = DispatchQueue(label: "DebugServicePlugin.webView")

    init() {
        DispatchQueue.main.async { [weak self] in
            self?.webView = WKWebView(frame: CGRect.zero)
            self?.webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] result, _ in
                if let userAgent = result as? String {
                    self?.userAgent = userAgent
                } else {
                    self?.userAgent = ""
                }
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
