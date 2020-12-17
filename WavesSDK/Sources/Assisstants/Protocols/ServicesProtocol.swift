//
//  ServicesProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation
import Moya

extension InternalWavesService {
    
    static func moyaProvider<Target: TargetType>(plugins: [PluginType]) -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: DispatchQueuePool.userInteractive,
                                    plugins: plugins)
    }
}
