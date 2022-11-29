//
//  ServicesFactoryProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation
import Moya

internal final class WavesServices: InternalWavesService, WavesServicesProtocol {
    
    private(set) var nodeServices: NodeServicesProtocol
    private(set) var dataServices: DataServicesProtocol
    private(set) var matcherServices: MatcherServicesProtocol
    
    override var enviroment: WavesEnvironment {
        
        didSet {
            
            [nodeServices,
             dataServices,
             matcherServices]
                .map { $0 as? InternalWavesService }
                .compactMap { $0 }
                .forEach { $0.enviroment = enviroment }
        }
    }
    
    init(enviroment: WavesEnvironment,
         dataServicePlugins: [PluginType],
         nodeServicePlugins: [PluginType],
         matcherServicePlugins: [PluginType]) {
        
        self.nodeServices = NodeServices(plugins: nodeServicePlugins,
                                         enviroment: enviroment)
        
        self.dataServices = DataServices(plugins: dataServicePlugins,
                                               enviroment: enviroment)
        
        self.matcherServices = MatcherServices(plugins: matcherServicePlugins,
                                               enviroment: enviroment)
        
        super.init(enviroment: enviroment)
        
        self.enviroment = enviroment
    }
}
