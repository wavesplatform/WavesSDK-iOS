//
//  AliasDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class AliasDataService: InternalWavesService, AliasDataServiceProtocol {
    
    private let aliasProvider: MoyaProvider<DataService.Target.Alias>
        
    init(aliasProvider: MoyaProvider<DataService.Target.Alias>, enviroment: WavesEnvironment) {
        self.aliasProvider = aliasProvider
        super.init(enviroment: enviroment)
    }
    
    public func alias(name: String) -> Observable<DataService.DTO.Alias> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.dataUrl,
                                       kind: .alias(name: name)))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<DataService.DTO.Alias>.self)
            .map { $0.data }
            .asObservable()
    }
    
    public func aliases(address: String) -> Observable<[DataService.DTO.Alias]> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.dataUrl,
                                       kind: .list(address: address)))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Alias>]>.self)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
}
