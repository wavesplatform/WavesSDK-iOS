//
//  AssetsDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class AssetsDataService: InternalWavesService, AssetsDataServiceProtocol {
    
    private let assetsProvider: MoyaProvider<DataService.Target.Assets>
    
    init(assetsProvider: MoyaProvider<DataService.Target.Assets>, enviroment: WavesEnvironment) {
        self.assetsProvider = assetsProvider
        super.init(enviroment: enviroment)
    }
    
    public func assets(ids: [String]) -> Observable<[DataService.DTO.Asset?]> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssets(ids: ids),
                           dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Asset?>]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.isoDecoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
    
    public func asset(id: String) -> Observable<DataService.DTO.Asset> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAsset(id: id),
                           dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<DataService.DTO.Asset>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { $0.data }
            .asObservable()
    }
    
    func searchAssets(search: String, limit: Int) -> Observable<[DataService.DTO.Asset]> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .search(text: search, limit: limit),
                           dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Asset>]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)            
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
}
