//
//  UtilsNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import WavesSDKExtensions
import Moya

extension NodeService.Target {
    
    struct Utils {
        enum Kind {
            case time
            
            case transactionSerialize(NodeService.Query.Transaction)
        }
        
        var nodeUrl: URL
        let kind: Kind
    }
}

extension NodeService.Target.Utils: NodeTargetType {
    
    private enum Constants {
        static let utils = "utils"
        static let time = "time"
    }
    
    var path: String {
        switch kind {
        case .time:
            return Constants.utils + "/" + Constants.time
            
        case .transactionSerialize:
            return "/utils/transactionSerialize"
        }
    }
    
    var method: Moya.Method {
        switch kind {
        case .time:
            return .get
        case .transactionSerialize:
            return .post
        }
    }
    
    var task: Task {
        switch kind {
        case .time:
            return .requestPlain
            
        case .transactionSerialize(let specification):
            return .requestParameters(parameters: specification.params, encoding: JSONEncoding.default)
        }
    }
}

