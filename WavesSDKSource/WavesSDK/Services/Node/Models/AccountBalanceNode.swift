//
//  AddressBalanceNodeService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    struct AddressBalance: Decodable {
        public let address: String
        public let confirmations: Int64
        public let balance: Int64
    }
}
