//
//  AliasApiService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 1/30/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation
import Moya

extension DataService.Target {
    
    struct Alias {
        enum Kind {
            case alias(name: String)
            case list(address: String)
        }
        
        let dataUrl: URL
        let kind: Kind
    }
}

extension DataService.Target.Alias: DataTargetType {

    private enum Constants {
        static let aliases = "aliases"
        static let address = "address"
    }
    
    var path: String {
        switch kind {
            
        case .alias(let name):
            return Constants.aliases + "/" + "\(name)"
            
        case .list:
            return Constants.aliases
        }
    }
    
    var method: Moya.Method {
       return .get
    }
    
    var task: Task {
        switch kind {
        case .alias:
            return .requestPlain
        
        case .list(let address):
            return .requestParameters(parameters: [Constants.address : address], encoding: URLEncoding.default)
        }
    }
}
