//
//  AliasApi.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 1/30/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.DTO {
    
    struct Alias: Decodable {
        public let alias: String
        public let address: String
    }
}
