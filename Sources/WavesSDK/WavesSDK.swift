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



/**
 *
 * WavesSDK is library for easy and simple co-working Waves blockchain platform and app based on the
 * reactive paradigm
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

  public class func initialization( servicesPlugins: ServicesPlugins = ServicesPlugins(),
                                    enviroment: WavesEnvironment = WavesEnvironment(),
                                    debug: Bool = true) {

    var dataPlugins = servicesPlugins.data
    var nodePlugins = servicesPlugins.node
    var matcherPlugins = servicesPlugins.matcher

    if debug {
      dataPlugins.append(DebugServicePlugin())
      nodePlugins.append(DebugServicePlugin())
      matcherPlugins.append(DebugServicePlugin())
    }

    let services = WavesServices(enviroment: enviroment,
                                 dataServicePlugins: dataPlugins,
                                 nodeServicePlugins: nodePlugins,
                                 matcherServicePlugins: matcherPlugins)

    WavesSDK.shared = WavesSDK(services: services, enviroment: enviroment)
  }
}
