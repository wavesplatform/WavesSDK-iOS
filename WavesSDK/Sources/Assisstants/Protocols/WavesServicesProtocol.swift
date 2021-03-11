//
//  WavesServicesProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation

public protocol WavesServicesProtocol {
    
    var nodeServices: NodeServicesProtocol { get }
    var dataServices: DataServicesProtocol { get }
    var matcherServices: MatcherServicesProtocol { get }
}

protocol InternalWavesServiceProtocol {
    var enviroment: WavesEnvironment { get set }
}
