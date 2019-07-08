//
//  DataService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

public enum DataService {}

public extension DataService {
    internal enum Target {}
    enum DTO {}
    enum Query {}
}

protocol DataTargetType: TargetType {
    var dataUrl: URL { get }
}

extension DataTargetType {
    
    private var dataVersion: String {
        return "/v0"
    }

    var baseURL: URL { return URL(string: "\(dataUrl.relativeString)\(dataVersion)")! }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ContentType.applicationJson.headers
    }
}
