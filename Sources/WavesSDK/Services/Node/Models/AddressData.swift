//
//  AddressData.swift
//  WavesSDK
//
//  Created by vvisotskiy on 25.03.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

extension NodeService.DTO {
    public struct AddressesData: Decodable {
        public let type: String
        public let value: Int64
        public let key: String
        
        public init(type: String, value: Int64, key: String) {
            self.type = type
            self.value = value
            self.key = key
        }
    }
}
