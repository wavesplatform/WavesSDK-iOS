//
//  UtilsNode.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 3/12/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
  enum Utils {}
}

public extension NodeService.DTO.Utils {

  struct Time: Decodable {
    public let system: Int64
    public let NTP: Int64
  }
}

public extension NodeService.DTO.Utils {

  struct ScriptEvaluation: Decodable{
    public struct Result: Decodable{
      public let type: String
      public let value: AnyCodable
    }
    public let address: String
    public let expr: String
    public let result: Result
    public let complexity: Int64?
  }
}




