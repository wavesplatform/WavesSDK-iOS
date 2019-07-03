//
//  AddressesNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

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
}
