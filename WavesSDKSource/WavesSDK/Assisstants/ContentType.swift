//
//  ContentType.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

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
