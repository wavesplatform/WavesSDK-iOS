//
//  AddressesNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public extension NodeService.DTO {
    struct WavesBalance: Decodable {
        public let id: String
        public let balance: Int64

        public init(id: String, balance: Int64) {
            self.id = id
            self.balance = balance
        }
    }
}

public protocol AddressesNodeServiceProtocol {
    /**
      Account's Waves balance
      - Parameter: address Address
     */
    func addressBalance(address: String) -> Observable<NodeService.DTO.AddressBalance>

    /**
      Account's script additional info
      - Parameter: address Address
     */

    func scriptInfo(address: String) -> Observable<NodeService.DTO.AddressScriptInfo>

    func getAddressData(address: String, key: String) -> Observable<NodeService.DTO.AddressesData>

    func addressesBalance(addresses: [String]) -> Observable<[NodeService.DTO.WavesBalance]>
}
