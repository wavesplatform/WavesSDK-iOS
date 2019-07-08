//
//  AddressesNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class AddressesNodeService: InternalWavesService, AddressesNodeServiceProtocol {
    
    private let addressesProvider: MoyaProvider<NodeService.Target.Addresses>
    
    init(addressesProvider: MoyaProvider<NodeService.Target.Addresses>, enviroment: Enviroment) {
        
        self.addressesProvider = addressesProvider
        super.init(enviroment: enviroment)
    }

    public func addressBalance(address: String) -> Observable<NodeService.DTO.AddressBalance> {
        
        return self
            .addressesProvider
            .rx
            .request(.init(kind: .getAddressBalance(id: address),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressBalance.self)
            .asObservable()
    }

    public func scriptInfo(address: String) -> Observable<NodeService.DTO.AddressScriptInfo> {
        return self
            .addressesProvider
            .rx
            .request(.init(kind: .scriptInfo(id: address),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressScriptInfo.self)
            .asObservable()
    }
}
