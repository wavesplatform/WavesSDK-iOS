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
        let target: NodeService.Target.Addresses = .init(kind: .getAddressBalance(id: address), nodeUrl: enviroment.nodeUrl)
        return addressesProvider
            .rx
            .request(target, callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError { error -> Single<Response> in Single.error(NetworkError.error(by: error)) }
            .map(NodeService.DTO.AddressBalance.self)
            .asObservable()
    }

    public func scriptInfo(address: String) -> Observable<NodeService.DTO.AddressScriptInfo> {
        let target: NodeService.Target.Addresses = .init(kind: .scriptInfo(id: address), nodeUrl: enviroment.nodeUrl)
        
        return addressesProvider
            .rx
            .request(target, callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError{ error -> Single<Response> in Single.error(NetworkError.error(by: error)) }
            .map(NodeService.DTO.AddressScriptInfo.self)
            .asObservable()
    }
    
    func getAddressData(addressSmartContract: String, key: String) -> Observable<NodeService.DTO.AddressesData> {
        let target: NodeService.Target.Addresses = .init(kind: .getData(addressSmartContract: addressSmartContract, key: key),
                                                         nodeUrl: enviroment.nodeUrl)
        
        return addressesProvider
            .rx
            .request(target)
            .map(NodeService.DTO.AddressesData.self)
            .catchErrorJustReturn(NodeService.DTO.AddressesData(type: "", value: 0, key: ""))
            .asObservable()
    }
}
