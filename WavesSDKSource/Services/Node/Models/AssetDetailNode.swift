//
//  AssetDetailNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 21/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    struct AssetDetail: Decodable {
        public let assetId: String
        public let issueHeight: Int64
        public let issueTimestamp: Int64
        public let issuer: String
        public let name: String
        public let description: String
        public let decimals: Int64
        public let reissuable: Bool
        public let quantity: Int64
        public let scripted: Bool?
        public let minSponsoredAssetFee: Int64?
    }
}
