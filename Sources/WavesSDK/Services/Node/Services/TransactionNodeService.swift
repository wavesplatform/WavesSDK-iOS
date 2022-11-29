//
//  TransactionNodeService.swift
//  Alamofire
//
//  Created by rprokofev on 26/04/2019.
//

import Foundation
import RxSwift
import Moya

final class TransactionNodeService: InternalWavesService, TransactionNodeServiceProtocol {

  private let transactionsProvider: MoyaProvider<NodeService.Target.Transaction>

  init(transactionsProvider: MoyaProvider<NodeService.Target.Transaction>, enviroment: WavesEnvironment) {
    self.transactionsProvider = transactionsProvider
    super.init(enviroment: enviroment)
  }

  public func transactions(query: NodeService.Query.Transaction) -> Observable<NodeService.DTO.Transaction> {

    return self
      .transactionsProvider
      .rx
      .request(.init(kind: .broadcast(query),
                     nodeUrl: enviroment.nodeUrl))
      .filterSuccessfulStatusAndRedirectCodes()
      .catch({ (error) -> Single<Response> in
        return Single.error(NetworkError.error(by: error))
      })
        .map(NodeService.DTO.Transaction.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
        .asObservable()
  }

  public func transactions(by address: String, offset: Int, limit: Int) -> Observable<NodeService.DTO.TransactionContainers> {

    return self
      .transactionsProvider
      .rx
      .request(.init(kind: .list(address: address,
                                 limit: limit),
                     nodeUrl: enviroment.nodeUrl))
      .filterSuccessfulStatusAndRedirectCodes()
      .catch({ (error) -> Single<Response> in
        return Single.error(NetworkError.error(by: error))
      })
        .map(NodeService.DTO.TransactionContainers.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
        .asObservable()
  }

  public func calculateFee(for tx: NodeService.Query.Transaction) -> Observable<NodeService.DTO.TransactionFee> {
    return self.transactionsProvider
      .rx
      .request(.init(kind: .calculateFee(tx), nodeUrl: enviroment.nodeUrl))
      .filterSuccessfulStatusAndRedirectCodes()
      .catch({ (error) -> Single<Response> in
        return Single.error(NetworkError.error(by: error))
      })
        .map(NodeService.DTO.TransactionFee.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
        .asObservable()
  }
}

