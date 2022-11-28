//
//  TransactionsDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class TransactionsDataService: InternalWavesService, TransactionsDataServiceProtocol {


  private let transactionsProvider: MoyaProvider<DataService.Target.Transactions>

  init(transactionsProvider: MoyaProvider<DataService.Target.Transactions>, enviroment: WavesEnvironment) {
    self.transactionsProvider = transactionsProvider
    super.init(enviroment: enviroment)
  }

  public func transactionsExchange(query: DataService.Query.ExchangeFilters)
  -> Observable<[DataService.DTO.ExchangeTransaction]> {

    transactionsProvider.rx
      .request(.init(kind: .getExchangeWithFilters(query),
                     dataUrl: enviroment.dataUrl))
      .filterSuccessfulStatusAndRedirectCodes()
      .catch { error -> Single<Response> in
        Single<Response>.error(NetworkError.error(by: error))
      }
      .map(DataService.Response<[DataService.Response<DataService.DTO.ExchangeTransaction>]>.self,
           atKeyPath: nil,
           using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
           failsOnEmptyData: false)
      .map { $0.data.map { $0.data } }
      .asObservable()
  }

  public func transactionsExchange(txId: String)
  -> Observable<DataService.DTO.ExchangeTransaction> {

    transactionsProvider.rx
      .request(.init(kind: .getExchange(id: txId),
                     dataUrl: enviroment.dataUrl))
      .filterSuccessfulStatusAndRedirectCodes()
      .catch { error -> Single<Response> in
        Single<Response>.error(NetworkError.error(by: error))
      }
      .map(DataService.Response<DataService.DTO.ExchangeTransaction>.self,
           atKeyPath: nil,
           using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
           failsOnEmptyData: false)
      .map {
        $0.data
      }
      .asObservable()
  }

  func getMassTransfer(txId: String) -> Observable<DataService.DTO.MassTransferTransaction> {
    let target = DataService.Target.Transactions(kind: .getMassTransfer(id: txId), dataUrl: enviroment.dataUrl)

    return transactionsProvider
      .rx
      .request(target)
      .catch { error -> Single<Response> in
        Single<Response>.error(NetworkError.error(by: error))
      }
      .map(MassTransferResponseAdapter.self,
           atKeyPath: nil,
           using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
           failsOnEmptyData: false)
      .map {
        $0.data
      }
      .catch { error -> Single<DataService.DTO.MassTransferTransaction> in
        Single<DataService.DTO.MassTransferTransaction>.error(NetworkError.error(by: error))
      }
      .asObservable()
  }

  public func getMassTransferTransactions(query: DataService.Query.MassTransferDataQuery)
  -> Observable<DataService.Response<[DataService.DTO.MassTransferTransaction]>> {

    let target = DataService.Target.Transactions(kind: .getMassTransferTransactions(query), dataUrl: enviroment.dataUrl)

    return transactionsProvider
      .rx
      .request(target)
      .catch { error -> Single<Response> in
        Single<Response>.error(NetworkError.error(by: error))
      }
      .map(DataService.Response<[MassTransferResponseAdapter]>.self,
           atKeyPath: nil,
           using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
           failsOnEmptyData: false)
      .map { adapteeMassTransferResponse -> DataService.Response<[DataService.DTO.MassTransferTransaction]> in
        // adaptable response is convertible to what is convenient for us
        let data = adapteeMassTransferResponse.data.map { $0.data }
        return DataService.Response<[DataService.DTO.MassTransferTransaction]>(type: adapteeMassTransferResponse.type,
                                                                               data: data,
                                                                               isLastPage: adapteeMassTransferResponse.isLastPage,
                                                                               lastCursor: adapteeMassTransferResponse.lastCursor)
      }
      .catch { error -> Single<DataService.Response<[DataService.DTO.MassTransferTransaction]>> in
        Single<DataService.Response<[DataService.DTO.MassTransferTransaction]>>.error(NetworkError.error(by: error))
      }
      .asObservable()
  }
}

extension TransactionsDataService {
  /// This structure helps us to pick up the answer that we need and not clog the external Namespace with unnecessary wrappers due to the imperfection of the back-end system

  fileprivate struct MassTransferResponseAdapter: Decodable {

    let type: String
    let data: DataService.DTO.MassTransferTransaction

    enum CodingKeys: String, CodingKey {
      case type = "__type"
      case data
    }
  }
}
