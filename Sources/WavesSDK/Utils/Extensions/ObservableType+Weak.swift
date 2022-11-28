//
//  ObservableType+Wea.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 10.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
  func `do`<WeakObject: AnyObject>(weak obj: WeakObject,
                                   onNext: ((WeakObject, Element) throws -> Swift.Void)? = nil,
                                   onError: ((WeakObject, Error) throws -> Swift.Void)? = nil,
                                   onCompleted: ((WeakObject) throws -> Swift.Void)? = nil,
                                   onSubscribe: ((WeakObject) -> Void)? = nil,
                                   onSubscribed: ((WeakObject) -> Void)? = nil,
                                   onDispose: ((WeakObject) -> Void)? = nil) -> RxSwift.Observable<Self.Element> {
    return `do`(onNext: { [weak obj] element in

      guard let obj = obj else { return }
      try onNext?(obj, element)
    }, onError: { [weak obj] error in

      guard let obj = obj else { return }
      try onError?(obj, error)
    }, onCompleted: { [weak obj] () in

      guard let obj = obj else { return }
      try onCompleted?(obj)
    }, onSubscribe: { [weak obj] () in

      guard let obj = obj else { return }
      onSubscribe?(obj)
    }, onSubscribed: { [weak obj] () in

      guard let obj = obj else { return }
      onSubscribed?(obj)
    }, onDispose: { [weak obj] () in

      guard let obj = obj else { return }
      onDispose?(obj)
    })
  }

  func catchError<WeakObject: AnyObject>(weak obj: WeakObject, handler: @escaping (WeakObject, Error) throws -> RxSwift.Observable<Self.Element>) -> RxSwift.Observable<Self.Element> {
    return self.catch { [weak obj] (error) -> Observable<Element> in

      guard let obj = obj else { return Observable<Element>.never() }

      return try handler(obj, error)
    }
  }

  func flatMap<O: ObservableConvertibleType,
               WeakObject: AnyObject>(weak obj: WeakObject,
                                      selector: @escaping (_ weak: WeakObject, Element) throws -> O) -> Observable<O.Element> {
    return flatMap { [weak obj] (element) -> Observable<O.Element> in

      guard let obj = obj else { return Observable<O.Element>.never() }

      return try selector(obj, element).asObservable()
    }
  }

  func flatMap<O: ObservableConvertibleType, WeakObject: AnyObject>(weak obj: WeakObject,
                                                                    selector: @escaping (WeakObject) -> (Self.Element) -> O) -> Observable<O.Element> {
    return flatMap { [weak obj] (element) -> Observable<O.Element> in

      guard let obj = obj else { return Observable<O.Element>.never() }

      return selector(obj)(element).asObservable()
    }
  }

  func subscribe<WeakObject: AnyObject>(weak obj: WeakObject,
                                        onError: ((WeakObject, Error) -> Void)? = nil) -> Disposable {
    return subscribe(weak: obj, onNext: nil, onError: onError, onCompleted: nil, onDisposed: nil)
  }

  func subscribe<WeakObject: AnyObject>(weak obj: WeakObject,
                                        onCompleted: ((WeakObject) -> Void)? = nil) -> Disposable {
    return subscribe(weak: obj, onNext: nil, onError: nil, onCompleted: onCompleted, onDisposed: nil)
  }

  func subscribe<WeakObject: AnyObject>(weak obj: WeakObject, _ on: @escaping (WeakObject, RxSwift.Event<Self.Element>) -> Void) -> Disposable {
    return subscribe { [weak obj] event in

      guard let obj = obj else { return }
      on(obj, event)
    }
  }

  func subscribe<WeakObject: AnyObject>(weak obj: WeakObject,
                                        onNext: ((WeakObject, Self.Element) -> Void)? = nil,
                                        onError: ((WeakObject, Error) -> Void)? = nil,
                                        onCompleted: ((WeakObject) -> Void)? = nil,
                                        onDisposed: ((WeakObject) -> Void)? = nil) -> Disposable {
    let disposable: Disposable

    if let disposed = onDisposed {
      disposable = Disposables.create { [weak obj] in
        guard let obj = obj else { return }
        disposed(obj)
      }
    } else {
      disposable = Disposables.create()
    }

    let observer = AnyObserver { [weak obj] (event: RxSwift.Event<Self.Element>) in
      guard let obj = obj else { return }
      switch event {
        case .next(let value):
          onNext?(obj, value)
        case .error(let error):
          onError?(obj, error)
          disposable.dispose()
        case .completed:
          onCompleted?(obj)
          disposable.dispose()
      }
    }

    return Disposables.create(asObservable().subscribe(observer), disposable)
  }
}
