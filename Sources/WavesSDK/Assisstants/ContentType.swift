//
//  ContentType.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

public enum ContentType {
    case applicationJson
    case applicationCsv
}

public extension ContentType {
    var headers: [String: String] {
        switch self {
        case .applicationCsv:
            return ["Content-type": "application/csv"]
            
        case .applicationJson:
            return ["Content-type": "application/json"]
        }
    }
}
