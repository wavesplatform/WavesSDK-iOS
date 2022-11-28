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
//import RxTest

import WavesSDK
import WavesSDKCrypto

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
        let fee: Int64 = 500000
        let amount: Int64 = 100000
        let feeAssetId = "WAVES"
        let assetId = "WAVES"
        let attachment = "asdasd"
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.Transfer(recipient: recipient,
                                                              assetId: assetId,
                                                              amount: amount,
                                                              fee: fee,
                                                              attachment: attachment,
                                                              feeAssetId: feeAssetId,
                                                              timestamp: timestamp,
                                                              senderPublicKey: senderPublicKey,
                                                              chainId: chainId)
        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.transfer(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testDataTx() {

        let fee: Int64 = 900000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        let data = NodeService.Query.Transaction.Data.Value.init(key: "size", value: .integer(10))

        let data1 = NodeService.Query.Transaction.Data.Value.init(key: "name", value: .string("Maks"))

        let data2 = NodeService.Query.Transaction.Data.Value.init(key: "isMan", value: .boolean(true))

        let binary = WavesCrypto.shared.base64encode(input: "Hello!".toBytes)

        let data3 = NodeService.Query.Transaction.Data.Value.init(key: "secret", value: .binary(binary))

        var queryModel = NodeService.Query.Transaction.Data.init(fee: fee,
                                                               timestamp: timestamp,
                                                               senderPublicKey: senderPublicKey,
                                                               data: [data, data1, data2, data3],
                                                               chainId: chainId)

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.data(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testInvokeTx() {

        let fee: Int64 = 900000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        let dApp: String = "3Mv9XDntij4ZRE1XiNZed6J74rncBpiYNDV"

        let arg1 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .string("Some string!"))
        let arg2 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .integer(128))
        let arg3 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .integer(-127))
        let arg4 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .bool(true))
        let arg5 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .bool(false))
        let arg6 = NodeService.Query.Transaction.InvokeScript.Arg.init(value: .binary("base64:VGVzdA=="))

        var queryModel = NodeService.Query.Transaction.InvokeScript.init(chainId: chainId,
                                                                           fee: fee,
                                                                           timestamp: timestamp,
                                                                           senderPublicKey: senderPublicKey,
                                                                           feeAssetId: "WAVES",
                                                                           dApp: dApp,
                                                                           call: .init(function: "testarg", args: [arg1, arg2, arg3,
                                                                                                                   arg4, arg5, arg6]),
                                                                           payment: [.init(amount: 1, assetId: "WAVES")])

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.invokeScript(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testBurnTx() {

        let fee: Int64 = 500000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.Burn.init(chainId: chainId,
                                                               fee: fee,
                                                               assetId: "C5XD7iTdyx868yRE7DS9BmqonF1TBcM5W2hfTEWW5Dfm",
                                                               quantity: 1,
                                                               timestamp: timestamp,
                                                               senderPublicKey: senderPublicKey)


        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.burn(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testReissueTx() {

        let fee: Int64 = 150000000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.Reissue.init(chainId: chainId,
                                                                  fee: fee,
                                                                  timestamp: timestamp,
                                                                  senderPublicKey: senderPublicKey,
                                                                  assetId: "C5XD7iTdyx868yRE7DS9BmqonF1TBcM5W2hfTEWW5Dfm",
                                                                  quantity: 1,
                                                                  isReissuable: true)

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.reissue(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testIssueTx() {

        let send = issueTx()

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testMassTransferTx() {

        let fee: Int64 = 900000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.MassTransfer.init(chainId: chainId,
                                                                       fee: fee,
                                                                       timestamp: timestamp,
                                                                       senderPublicKey: senderPublicKey,
                                                                       assetId: "",
                                                                       attachment: "Vas9",
                                                                       transfers: [.init(recipient: "3N44AAuDdk86roSvuURuKez4Br5wrccxfhy",
                                                                                         amount: 10000),
                                                                                   .init(recipient: "3N44AAuDdk86roSvuURuKez4Br5wrccxfhy",
                                                                                         amount: 200000)])

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.massTransfer(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    // MARK: Alias

    func testCreateAliasTx() {

        let fee: Int64 = 500000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        let number = String.random(length: 29, letters: "-.0123456789@_abcdefghijklmnopqrstuvwxyz")

        var queryModel = NodeService.Query.Transaction.Alias.init(chainId: chainId,
                                                                name: number,
                                                                fee: fee,
                                                                timestamp: timestamp,
                                                                senderPublicKey: senderPublicKey)

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.createAlias(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    // MARK: Lease
    func testCreateLeaseTx() {

        let send = leaseTx()

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testCancelLeaseTx() {

        let send = leaseTx()

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in

                return Observable<Int>.timer(DispatchTimeInterval.seconds(10), scheduler: MainScheduler.asyncInstance).map { _ in tx }
            })
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in

                guard case .lease(let txLease) = tx else {
                    return Observable.never()
                }

                let fee: Int64 = 500000
                let timestamp = Int64(Date().timeIntervalSince1970) * 1000

                var queryModel = NodeService.Query.Transaction.LeaseCancel.init(chainId: self.chainId,
                                                                              fee: fee,
                                                                              leaseId: txLease.id,
                                                                              timestamp: timestamp,
                                                                              senderPublicKey: self.senderPublicKey)

                queryModel.sign(seed: self.seed)

                return WavesSDK.shared.services
                    .nodeServices
                    .transactionNodeService
                    .transactions(query: NodeService.Query.Transaction.cancelLease(queryModel))
            })
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 40)
    }

    func testSetScriptEnableTx() {

        let fee: Int64 = 1500000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.SetScript.init(chainId: chainId,
                                                                     fee: fee,
                                                                     timestamp: timestamp,
                                                                     senderPublicKey: senderPublicKey,
                                                                     script: "base64:AwZd0cYf")

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.setScript(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testSetScriptCancelTx() {

        let fee: Int64 = 1400000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.SetScript.init(chainId: chainId,
                                                                    fee: fee,
                                                                    timestamp: timestamp,
                                                                    senderPublicKey: senderPublicKey,
                                                                    script: "")

        queryModel.sign(seed: seed)

        let send = NodeService.Query.Transaction.setScript(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 20)
    }

    func testAssetScriptTx() {

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: issueTx(script: "AwZd0cYf"))
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in
                return Observable<Int>.timer(DispatchTimeInterval.seconds(10), scheduler: MainScheduler.asyncInstance).map { _ in tx }
            })
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in

                guard case .issue(let txIssue) = tx else {
                    return Observable.never()
                }

                let fee: Int64 = 100400000
                let timestamp = Int64(Date().timeIntervalSince1970) * 1000

                var queryModel = NodeService.Query.Transaction.SetAssetScript.init(chainId: self.chainId,
                                                                                 fee: fee,
                                                                                 timestamp: timestamp,
                                                                                 senderPublicKey: self.senderPublicKey,
                                                                                 script: "AwZd0cYf",
                                                                                 assetId: txIssue.assetId)

                queryModel.sign(seed: self .seed)

                let send = NodeService.Query.Transaction.setAssetScript(queryModel)
                return  WavesSDK.shared.services
                    .nodeServices
                    .transactionNodeService
                    .transactions(query: send)
            })
            .observeOn(MainScheduler.asyncInstance)
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 40)
    }

    func testSponsorshipTx() {

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: issueTx())
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in
                return Observable<Int>.timer(DispatchTimeInterval.seconds(20), scheduler: MainScheduler.asyncInstance).map { _ in tx }
            })
            .flatMap({ (tx) -> Observable<NodeService.DTO.Transaction> in

                guard case .issue(let txIssue) = tx else {
                    return Observable.never()
                }

                let fee: Int64 = 100400000
                let timestamp = Int64(Date().timeIntervalSince1970) * 1000

                var queryModel = NodeService.Query.Transaction.Sponsorship.init(chainId: self.chainId,
                                                                              fee: fee,
                                                                              timestamp: timestamp,
                                                                              senderPublicKey: self.senderPublicKey,
                                                                              minSponsoredAssetFee: 2,
                                                                              assetId: txIssue.assetId)

                queryModel.sign(seed: self.seed)

                let send = NodeService.Query.Transaction.sponsorship(queryModel)

                return WavesSDK.shared.services
                    .nodeServices
                    .transactionNodeService
                    .transactions(query: send)

            })
            .executionDebug(expectation: expectation)

        wait(for: [expectation], timeout: 40)
    }
}

private extension WavesServicesBroadcastTransactionsTest {

    func leaseTx() -> NodeService.Query.Transaction {

        let fee: Int64 = 500000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000


        var queryModel = NodeService.Query.Transaction.Lease(chainId: chainId,
                                                           fee: fee,
                                                           recipient: "3MsqCHCg5pkdPCk2nvfjzddcXeZFaPR8qYS",
                                                           amount: 1,
                                                           timestamp: timestamp,
                                                           senderPublicKey: senderPublicKey)

        queryModel.sign(seed: seed)

        return NodeService.Query.Transaction.startLease(queryModel)
    }

    func issueTx(script: String? = nil) -> NodeService.Query.Transaction {

        let fee: Int64 = 100400000
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Transaction.Issue.init(chainId: chainId,
                                                                fee: fee,
                                                                timestamp: timestamp,
                                                                senderPublicKey: senderPublicKey,
                                                                quantity: 100,
                                                                isReissuable: true,
                                                                name: "Maks",
                                                                description: "Mega token",
                                                                script: script,
                                                                decimals: 2)

        queryModel.sign(seed: seed)

        return NodeService.Query.Transaction.issue(queryModel)
    }
}
