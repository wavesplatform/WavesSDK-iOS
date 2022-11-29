//
//  File.swift
//  
//
//  Created by Leonardo Marques on 31/7/22.
//

import Foundation
import Moya

extension DataService.Target {

  struct Matcher {
    enum Kind {
      /**
       Response:
       - API.Response<[API.Response<API.Model.Asset>]>.self
       */
      case getAssets(ids: [String])
      /**
       Response:
       - API.Response<API.Model.Asset>.self
       */
      case getAsset(id: String)

      case search(text: String, limit: Int)
    }

    let kind: Kind
    let dataUrl: URL
  }
}
