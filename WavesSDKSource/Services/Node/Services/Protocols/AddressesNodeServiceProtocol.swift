//
//  AddressesNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AddressesNodeServiceProtocol {
    
    func accountBalance(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountBalance>
    
    func scriptInfo(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AddressScriptInfo>
}
