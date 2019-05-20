//
//  AssetsDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol AssetsDataServiceProtocol {
    
    func assets(ids: [String], enviroment: EnviromentService) -> Observable<[DataService.DTO.Asset]>
    
    func asset(id: String, enviroment: EnviromentService) -> Observable<DataService.DTO.Asset>
}

final class AssetsDataService: AssetsDataServiceProtocol {
    
    private let assetsProvider: MoyaProvider<DataService.Target.Assets>
    
    init(assetsProvider: MoyaProvider<DataService.Target.Assets>) {
        self.assetsProvider = assetsProvider
    }
    
    public func assets(ids: [String], enviroment: EnviromentService) -> Observable<[DataService.DTO.Asset]> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssets(ids: ids),
                           dataUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Asset>]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
    
    public func asset(id: String, enviroment: EnviromentService) -> Observable<DataService.DTO.Asset> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAsset(id: id),
                           dataUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<DataService.DTO.Asset>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { $0.data }
            .asObservable()
    }
}
