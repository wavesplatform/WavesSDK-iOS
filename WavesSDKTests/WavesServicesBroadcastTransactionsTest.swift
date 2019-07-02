//
//  WavesServicesBroadcastTransactions.swift
//  WavesSDKTests
//
//  Created by rprokofev on 28.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest
import WavesSDK
import WavesSDKExtensions
import Nimble
import Fakery

public class XCTestExpectationReactive: XCTestExpectation {
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    public func execution<E>(observer: Observable<E>, success: @escaping (E) -> Void, fail: @escaping (Error) -> Void) {
        observer.subscribe(onNext: { (object) in

            success(object)
            self.fulfillAsync()
        }, onError: { (error) in
            fail(error)
            self.fulfillAsync()
        }, onCompleted: {
            self.fulfillAsync()
        }) {
            self.fulfillAsync()
        }
        .disposed(by: disposeBag)
    }
    
    public func executionDebug<E>(observer: Observable<E>) {
        self.execution(observer: observer, success: { (element) in
            print(element)
            XCTAssertTrue(true)
        }) { (error) in
            print(error)
            XCTFail()
        }
    }
    
    private func fulfillAsync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.fulfill()
        }
    }
}

public extension Observable {
    
    func execution(expectation: XCTestExpectationReactive, success: @escaping (Element) -> Void, fail: @escaping (Error) -> Void) {
        expectation.execution(observer: self, success: success, fail: fail)
    }
    
    func executionDebug(expectation: XCTestExpectationReactive) {
        expectation.executionDebug(observer: self)
    }
}

class WavesServicesBroadcastTransactionsTest: WavesServicesTest {
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    let expectation = XCTestExpectationReactive(description: "tx")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {}
    
    func testTransferTx() {

        let recipient = address!
        let fee: Int64 = 100000
        let amount: Int64 = 100000
        let feeAssetId = ""
        let assetId = ""
        let attachment = ""
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Broadcast.Transfer(recipient: recipient,
                                                              assetId: assetId,
                                                              amount: amount,
                                                              fee: fee,
                                                              attachment: attachment,
                                                              feeAssetId: feeAssetId,
                                                              timestamp: timestamp,
                                                              senderPublicKey: senderPublicKey,
                                                              scheme: chainId)
        queryModel.sign(seed: seed)

        let send = NodeService.Query.Broadcast.transfer(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testDataTx() {
        
        let fee: Int64 = 400000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        
        let data = NodeService.Query.Broadcast.Data.Value.init(key: "size", value: .integer(10))
        
        let data1 = NodeService.Query.Broadcast.Data.Value.init(key: "name", value: .string("Maks"))
        
        let data2 = NodeService.Query.Broadcast.Data.Value.init(key: "isGay", value: .boolean(true))
        
        let data3 = NodeService.Query.Broadcast.Data.Value.init(key: "secret", value: .binary("base64:SGVsbG8h"))

        var queryModel = NodeService.Query.Broadcast.Data.init(fee: fee,
                                                               timestamp: timestamp,
                                                               senderPublicKey: senderPublicKey,
                                                               data: [data, data1, data2, data3],
                                                               scheme: chainId)
        
        queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Broadcast.data(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testInvokeTx() {
        
        let fee: Int64 = 500000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        let dApp: String = "3Mv9XDntij4ZRE1XiNZed6J74rncBpiYNDV"
        
        let arg1 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .string("Some string!"))
        let arg2 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .integer(128))
        let arg3 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .integer(-127))
        let arg4 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .bool(true))
        let arg5 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .bool(false))
        let arg6 = NodeService.Query.Broadcast.InvokeScript.Arg.init(value: .binary("base64:VGVzdA=="))
        
        var queryModel = NodeService.Query.Broadcast.InvokeScript.init(scheme: chainId,
                                                                       fee: fee,
                                                                       timestamp: timestamp,
                                                                       senderPublicKey: senderPublicKey,
                                                                       feeAssetId: "",
                                                                       dApp: dApp,
                                                                       call: .init(function: "testarg", args: [arg1, arg2, arg3,
                                                                                                               arg4, arg5, arg6]),
                                                                       payment: [.init(amount: 1, assetId: "")])
        
        queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Broadcast.invokeScript(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }

    func testBurnTx() {
        
        let fee: Int64 = 300000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Broadcast.Burn.init(scheme: chainId,
                                                               fee: fee,
                                                               assetId: "C5XD7iTdyx868yRE7DS9BmqonF1TBcM5W2hfTEWW5Dfm",
                                                               quantity: 1,
                                                               timestamp: timestamp,
                                                               senderPublicKey: senderPublicKey)
                                                               
        
        queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Broadcast.burn(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testReissueTx() {
        
        let fee: Int64 = 100000000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        
        var queryModel = NodeService.Query.Broadcast.Reissue.init(scheme: chainId,
                                                                  fee: fee,
                                                                  feeAssetId: "",
                                                                  timestamp: timestamp,
                                                                  senderPublicKey: senderPublicKey,
                                                                  assetId: "C5XD7iTdyx868yRE7DS9BmqonF1TBcM5W2hfTEWW5Dfm",
                                                                  quantity: 1,
                                                                  isReissuable: true)
        
        queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Broadcast.reissue(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }

    func testIssueTx() {
        
        let fee: Int64 = 100000000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        
        var queryModel = NodeService.Query.Broadcast.Reissue.init(scheme: chainId,
                                                                  fee: fee,
                                                                  feeAssetId: "",
                                                                  timestamp: timestamp,
                                                                  senderPublicKey: senderPublicKey,
                                                                  assetId: "C5XD7iTdyx868yRE7DS9BmqonF1TBcM5W2hfTEWW5Dfm",
                                                                  quantity: 1,
                                                                  isReissuable: true)
        
        queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Broadcast.reissue(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)
        
        wait(for: [expectation], timeout: 20)
    }
}


//    case createLease = 8
//    case cancelLease = 9

//    case exchange = 7


//case issue = 3
//    case massTransfer = 11
//    case script = 13
//    case sponsorship = 14
//    case assetScript = 15

