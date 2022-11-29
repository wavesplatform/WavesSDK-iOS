//
//  TransactionsService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

extension DataService.Target {

  struct Transactions {
    enum Kind {

      /**
       Response:
       - API.Response<[API.Response<API.DTO.ExchangeTransaction]>.self
       */
      case getExchange(id: String)
      case getExchangeWithFilters(DataService.Query.ExchangeFilters)

      case getMassTransfer(id: String)
      case getMassTransferTransactions(DataService.Query.MassTransferDataQuery)

    }

    let kind: Kind
    let dataUrl: URL
  }
}

extension DataService.Target.Transactions: DataTargetType {

  private enum Constants {
    static let exchange = "transactions/exchange"
    static let massTransfer = "transactions/mass-transfer"
  }

  var path: String {
    switch kind {
      case .getExchange(let id): return Constants.exchange + "/\(id.urlEscaped)"

      case .getExchangeWithFilters: return Constants.exchange

      case .getMassTransferTransactions: return Constants.massTransfer
      case .getMassTransfer(let id): return Constants.massTransfer + "/\(id.urlEscaped)"
    }
  }

  var method: Moya.Method {
    switch kind {
      case .getExchange, .getExchangeWithFilters, .getMassTransferTransactions, .getMassTransfer:
        return .get
    }
  }

  var task: Task {
    switch kind {
      case .getExchange, .getMassTransfer:
        return .requestPlain

      case .getExchangeWithFilters(let filter):
        return .requestParameters(parameters: filter.dictionary, encoding: URLEncoding.default)

      case .getMassTransferTransactions(let query):
        return .requestParameters(parameters: query.dictionary, encoding: URLEncoding.default)
    }
  }
}
