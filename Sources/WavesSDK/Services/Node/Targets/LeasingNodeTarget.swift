//
//  LeasingNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation

import Moya

extension NodeService.Target {
    
    struct Leasing {
        enum Kind {
            /**
             Response:
             - [Node.Model.LeasingTransaction].self
             */
            case getActive(address: String)
        }
        
        var kind: Kind
        var nodeUrl: URL
    }
}

extension NodeService.Target.Leasing: NodeTargetType {
    var modelType: Encodable.Type {
        return String.self
    }
    
    fileprivate enum Constants {
        static let leasing = "leasing"
        static let active = "active"
        static let address = "address"
    }
    
    var path: String {
        switch kind {
        case .getActive(let address):
            return Constants.leasing + "/" + Constants.active + "/" + "\(address)".urlEscaped
        }
    }
    
    var method: Moya.Method {
        switch kind {
        case .getActive:
            return .get
        }
    }
    
    var task: Task {
        switch kind {
        case .getActive:
            return .requestPlain
        }
    }
}

