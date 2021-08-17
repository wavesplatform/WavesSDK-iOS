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
        public let value: AnyDecodable
        public let key: String
        
        public init(type: String, value: AnyDecodable, key: String) {
            self.type = type
            self.value = value
            self.key = key
        }
    }
    
    
    public struct AnyDecodable : Decodable {
      
     public let value :Any
      
      public init<T>(_ value :T?) {
        self.value = value ?? ()
      }
      
      public init(from decoder :Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
          self.init(string)
        } else if let int = try? container.decode(Int64.self) {
          self.init(int)
        } else {
          self.init(())
        }
        // handle all the different types including bool, array, dictionary, double etc
      }
    }
}
