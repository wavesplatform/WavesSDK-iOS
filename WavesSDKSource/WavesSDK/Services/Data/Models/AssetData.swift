//
//  Asset.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.DTO {
    struct Asset: Decodable {
        public let ticker: String?
        public let id: String
        public let name: String
        public let precision: Int
        public let description: String
        public let height: Int64
        public let timestamp: Date
        public let sender: String
        public let quantity: Int64
        public let reissuable: Bool
        public let hasScript: Bool
        public let minSponsoredFee: Int64?
    }
}
