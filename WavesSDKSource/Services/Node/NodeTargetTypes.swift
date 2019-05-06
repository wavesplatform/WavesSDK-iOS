//
//  NodeTargetType.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Result
import Moya

public enum Node {}

public extension Node {
    enum DTO {}
    enum Query {}
    internal enum Service {}
}

protocol NodeTargetType: TargetType {
    var nodeUrl: URL { get }
}

extension NodeTargetType {
    
    var baseURL: URL { return nodeUrl }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ContentType.applicationJson.headers
    }
}

extension MoyaProvider {
    
    final class func nodeMoyaProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                            plugins: [])
        //TODO: Library
//        SentryNetworkLoggerPlugin(), NodePlugin()
    }
}


final class ServicesFactory {
    
    private let dataServicePlugins: [PluginType]
    private let nodeServicePlugins: [PluginType]
    private let matcherrServicePlugins: [PluginType]
    
    init(dataServicePlugins: [PluginType],
         nodeServicePlugins: [PluginType],
         matcherrServicePlugins: [PluginType]) {
        
        self.dataServicePlugins = dataServicePlugins
        self.nodeServicePlugins = nodeServicePlugins
        self.matcherrServicePlugins = matcherrServicePlugins
    }
    
    
    static var shared: ServicesFactory?
}


//TODO: Library
enum ContentType {
    case applicationJson
    case applicationCsv
}

extension ContentType {
    var headers: [String: String] {
        switch self {
        case .applicationCsv:
            return ["Content-type": "application/csv"]
            
        case .applicationJson:
            return ["Content-type": "application/json"]
        }
    }
}
