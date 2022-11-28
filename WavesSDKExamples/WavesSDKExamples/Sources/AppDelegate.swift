//
//  AppDelegate.swift
//  WavesSDK
//
//  Created by rprokofev on 03/04/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import UIKit
import WavesSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        SweetLogger.current.add(plugins: [SweetLoggerConsole(visibleLevels: [.network, .error], isShortLog: false)])
        SweetLogger.current.visibleLevels = [.network, .error]
        
        WavesSDK.initialization(servicesPlugins: .init(data: [],
                                                       node: [],
                                                       matcher: []),
                                enviroment: .init(server: .mainNet, timestampServerDiff: 0))
        
        
                
        return true
    }
}
