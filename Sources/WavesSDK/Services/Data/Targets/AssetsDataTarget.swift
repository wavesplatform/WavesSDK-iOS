//
//  AssetsService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 06.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya


extension DataService.Target {

    struct Assets {
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

extension DataService.Target.Assets: DataTargetType {
    fileprivate enum Constants {
        static let assets = "assets"
        static let ids = "ids"
    }

    var path: String {
        switch kind {
        case .getAsset(let id):
            return Constants.assets + "/" + "\(id)".urlEscaped
        case .getAssets, .search:
            return Constants.assets
        }
    }

    var method: Moya.Method {
        switch kind {
        case .getAsset:
            return .get
        case .getAssets, .search:
            return .post
        }
    }

    var task: Task {
        switch kind {
        case .getAssets(let ids):
            return Task.requestParameters(parameters: [Constants.ids: ids],
                                          encoding: JSONEncoding.default)
            
        case .search(let string, let limit):
            return Task.requestParameters(parameters: ["search": string, "limit": limit],
                                          encoding: JSONEncoding.default)
        case .getAsset:
            return .requestPlain
        }
    }
}
