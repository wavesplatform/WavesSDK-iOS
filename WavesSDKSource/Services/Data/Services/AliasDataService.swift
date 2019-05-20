//
//  AliasDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol AliasDataServiceProtocol {
    
    func alias(name: String, enviroment: EnviromentService) -> Observable<DataService.DTO.Alias>
    
    func list(address: String, enviroment: EnviromentService) -> Observable<[DataService.DTO.Alias]>
}

final class AliasDataService: AliasDataServiceProtocol {
    
    private let aliasProvider: MoyaProvider<DataService.Target.Alias>
    
    init(aliasProvider: MoyaProvider<DataService.Target.Alias>) {
        self.aliasProvider = aliasProvider
    }
    
    public func alias(name: String, enviroment: EnviromentService) -> Observable<DataService.DTO.Alias> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.serverUrl,
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
    
    public func list(address: String, enviroment: EnviromentService) -> Observable<[DataService.DTO.Alias]> {
        
        return self
            .aliasProvider
            .rx
            .request(DataService.Target.Alias(dataUrl: enviroment.serverUrl,
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
