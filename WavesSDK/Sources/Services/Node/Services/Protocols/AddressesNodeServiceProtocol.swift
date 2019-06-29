//
//  AddressesNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AddressesNodeServiceProtocol {
    
    func addressBalance(address: String) -> Observable<NodeService.DTO.AddressBalance>
    
    func scriptInfo(address: String) -> Observable<NodeService.DTO.AddressScriptInfo>
}
