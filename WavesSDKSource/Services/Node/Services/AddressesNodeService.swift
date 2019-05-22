//
//  AddressesNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class AddressesNodeService: AddressesNodeServiceProtocol {
    
    private let addressesProvider: MoyaProvider<NodeService.Target.Addresses>
    
    init(addressesProvider: MoyaProvider<NodeService.Target.Addresses>) {
        self.addressesProvider = addressesProvider
    }
    
    public func accountBalance(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountBalance> {
        
        return self
            .addressesProvider
            .rx
            .request(.init(kind: .getAccountBalance(id: address),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AccountBalance.self)
            .asObservable()
    }
    
    public func scriptInfo(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AddressScriptInfo> {
        return self
            .addressesProvider
            .rx
            .request(.init(kind: .scriptInfo(id: address),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressScriptInfo.self)
            .asObservable()
    }
}
