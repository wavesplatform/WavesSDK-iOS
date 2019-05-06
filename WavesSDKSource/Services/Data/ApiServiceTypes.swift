//
//  DataService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

enum API {}

extension API {
    enum Service {}
    enum DTO {}
    enum Query {}
}

protocol ApiTargetType: TargetType {
    var apiUrl: URL { get }
}

extension ApiTargetType {
    
    private var apiVersion: String {
        return "/v0"
    }

    var baseURL: URL { return URL(string: "\(apiUrl.relativeString)\(apiVersion)")! }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ContentType.applicationJson.headers
    }
}
