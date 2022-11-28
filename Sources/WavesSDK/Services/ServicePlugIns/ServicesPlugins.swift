//
//  ServicesPlugins.swift
//  
//
//  Created by Leonardo Marques on 27/7/22.
//

import Foundation
import Moya

public struct ServicesPlugins {
  public let data: [PluginType]
  public let node: [PluginType]
  public let matcher: [PluginType]

  public init(data: [PluginType] = [],
              node: [PluginType] = [],
              matcher: [PluginType] = []) {
    self.data = data
    self.node = node
    self.matcher = matcher
  }
}
