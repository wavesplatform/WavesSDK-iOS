//
//  AddressesNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import Moya
import RxSwift

final class AddressesNodeService: InternalWavesService, AddressesNodeServiceProtocol {
    private let addressesProvider: MoyaProvider<NodeService.Target.Addresses>

    init(addressesProvider: MoyaProvider<NodeService.Target.Addresses>, enviroment: WavesEnvironment) {
        self.addressesProvider = addressesProvider
        super.init(enviroment: enviroment)
    }

    public func addressBalance(address: String) -> Observable<NodeService.DTO.AddressBalance> {
        let target: NodeService.Target.Addresses = .init(kind: .getAddressBalance(id: address), nodeUrl: enviroment.nodeUrl)
        return addressesProvider
            .rx
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .catch { (error) -> Single<Response> in Single.error(NetworkError.error(by: error)) }
            .map(NodeService.DTO.AddressBalance.self)
            .asObservable()
    }

    public func scriptInfo(address: String) -> Observable<NodeService.DTO.AddressScriptInfo> {
        let target: NodeService.Target.Addresses = .init(kind: .scriptInfo(id: address), nodeUrl: enviroment.nodeUrl)

        return addressesProvider
            .rx
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .catch { error -> Single<Response> in Single.error(NetworkError.error(by: error)) }
            .map(NodeService.DTO.AddressScriptInfo.self)
            .asObservable()
    }

    func getAddressData(address: String, key: String) -> Observable<NodeService.DTO.AddressesData> {
        let target: NodeService.Target.Addresses = .init(kind: .getData(address: address, key: key),
                                                         nodeUrl: enviroment.nodeUrl)

        return addressesProvider
            .rx
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .catch { error -> Single<Response> in Single.error(error) }
            .map(NodeService.DTO.AddressesData.self)
            .asObservable()
    }

    func addressesBalance(addresses: [String]) -> Observable<[NodeService.DTO.WavesBalance]> {
        let target: NodeService.Target.Addresses = .init(
            kind: .getAddressesBalance(addresses: addresses),
            nodeUrl: enviroment.nodeUrl)
        
        return addressesProvider
            .rx
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .catch { (error) -> Single<Response> in Single.error(NetworkError.error(by: error)) }
            .map([NodeService.DTO.WavesBalance].self)
            .asObservable()
    }
}
