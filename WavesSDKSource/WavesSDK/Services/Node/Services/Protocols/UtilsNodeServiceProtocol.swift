//
//  UtilsNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol UtilsNodeServiceProtocol {
    
    func time() -> Observable<NodeService.DTO.Utils.Time>
}
