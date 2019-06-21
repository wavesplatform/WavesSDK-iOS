//
//  AliasDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class AliasDataService: AliasDataServiceProtocol {
    
    private let aliasProvider: MoyaProvider<DataService.Target.Alias>
    
    var enviroment: Enviroment
    
    init(aliasProvider: MoyaProvider<DataService.Target.Alias>, enviroment: Enviroment) {
        self.aliasProvider = aliasProvider
        self.enviroment = enviroment
    }
    
    public func alias(name: String) -> Observable<DataService.DTO.Alias> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.dataUrl,
                                       kind: .alias(name: name)),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<DataService.DTO.Alias>.self)
            .map { $0.data }
            .asObservable()
    }
    
    public func list(address: String) -> Observable<[DataService.DTO.Alias]> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.dataUrl,
                                       kind: .list(address: address)),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.Alias>]>.self)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
}
