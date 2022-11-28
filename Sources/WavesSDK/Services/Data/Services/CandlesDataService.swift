//
//  CandlesDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class CandlesDataService: InternalWavesService, CandlesDataServiceProtocol {
    
    private let candlesProvider: MoyaProvider<DataService.Target.Candles>
        
    init(candlesProvider: MoyaProvider<DataService.Target.Candles>, enviroment: WavesEnvironment) {
        self.candlesProvider = candlesProvider
        super.init(enviroment: enviroment)
    }
    
    public func candles(query: DataService.Query.CandleFilters) -> Observable<DataService.DTO.Chart> {
        
        return self
            .candlesProvider
            .rx
            .request(.init(query: query,
                           dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Chart.Candle>]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map({ (response) -> DataService.DTO.Chart in
                return DataService.DTO.Chart(candles: response.data.map { $0.data } )
            })
            .asObservable()
    }
}
