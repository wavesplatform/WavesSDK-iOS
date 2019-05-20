//
//  AddressScriptInfo.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 21/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    struct AddressScriptInfo: Decodable {
        public let address: String
        public let complexity: Int64
        public let extraFee: Int64?
    }
}
