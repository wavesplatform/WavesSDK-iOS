//
//  Response.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService {
    struct Response<T: Decodable>: Decodable {
        public let type: String
        public let data: T
        public let isLastPage: Bool?
        public let lastCursor: String?
        
        public init(type: String, data: T, isLastPage: Bool?, lastCursor: String?) {
            self.type = type
            self.data = data
            self.isLastPage = isLastPage
            self.lastCursor = lastCursor
        }

        enum CodingKeys: String, CodingKey {
            case type = "__type"
            case data
            case isLastPage
            case lastCursor
        }
    }
    
    struct OptionalResponse<T: Decodable>: Decodable {
        public let type: String
        public let data: T?
        public let isLastPage: Bool?
        public let lastCursor: String?
        
        enum CodingKeys: String, CodingKey {
            case type = "__type"
            case data
            case isLastPage
            case lastCursor
        }
    }
}
