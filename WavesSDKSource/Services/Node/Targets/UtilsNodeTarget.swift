//
//  UtilsNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import WavesSDKExtension
import Moya

extension NodeService.Target {
    
    struct Utils {
        enum Kind {
            case time
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
        }
    }
    
    var method: Moya.Method {
        switch kind {
        case .time:
            return .get
        }
    }
    
    var task: Task {
        switch kind {
        case .time:
            return .requestPlain
        }
    }
}

