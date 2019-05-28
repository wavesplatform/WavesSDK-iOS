//
//  ServicesProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation
import Moya

public protocol ServicesProtocol {
    var enviroment: Enviroment { get set }
}

extension ServicesProtocol {
    
    static func moyaProvider<Target: TargetType>(plugins: [PluginType]) -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                                    plugins: plugins)
    }
}
