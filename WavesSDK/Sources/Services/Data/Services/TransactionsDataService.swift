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
            .catchError { error -> Single<Response> in
                Single<Response>.error(NetworkError.error(by: error))
        }
        .map(DataService.Response<[DataService.Response<DataService.DTO.ExchangeTransaction>]>.self,
             atKeyPath: nil,
             using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
             failsOnEmptyData: false)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
    
    public func getMassTransferTransactions(query: DataService.Query.MassTransferDataQuery)
        -> Observable<DataService.Response<[DataService.DTO.MassTransferTransaction]>> {

        let target = DataService.Target.Transactions(kind: .getMassTransferTransactions(query), dataUrl: enviroment.dataUrl)
        
        return transactionsProvider
            .rx
            .request(target)
            .catchError { error -> Single<Response> in
                Single<Response>.error(NetworkError.error(by: error))
            }
            .map(DataService.Response<[MassTransferResponseAdapter]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { adapteeMassTransferResponse -> DataService.Response<[DataService.DTO.MassTransferTransaction]> in
                // адаптируемый ответ конвертим в то, что нам удобно
                let data = adapteeMassTransferResponse.data.map { $0.data }
                return DataService.Response<[DataService.DTO.MassTransferTransaction]>(type: adapteeMassTransferResponse.type,
                                                                                       data: data,
                                                                                       isLastPage: adapteeMassTransferResponse.isLastPage,
                                                                                       lastCursor: adapteeMassTransferResponse.lastCursor)
            }
            .catchError { error -> Single<DataService.Response<[DataService.DTO.MassTransferTransaction]>> in
                Single<DataService.Response<[DataService.DTO.MassTransferTransaction]>>.error(NetworkError.error(by: error))
            }
            .asObservable()
    }
}

extension TransactionsDataService {
    /// Данная структура помогает нам забрать ответ который нам необходим и не засорять внешний Namespace ненужными обертками из-за несовершенства back-end системы
    fileprivate struct MassTransferResponseAdapter: Decodable {
        
        let type: String
        let data: DataService.DTO.MassTransferTransaction
        
        enum CodingKeys: String, CodingKey {
            case type = "__type"
            case data
        }
    }
}
