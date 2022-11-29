//
//  DebugServicePlugin.swift
//  
//
//  Created by Leonardo Marques on 27/7/22.
//

import Foundation
import Moya
import WebKit

/**
 *
 * Plugin to debug network requests. It is added to all services if the library is initialized with debug = true
 *
 */

final class DebugServicePlugin: PluginType {
  private var userAgent: String = ""

  private var webView: WKWebView?

  static let serialQueue = DispatchQueue(label: "DebugServicePlugin")
  static let serialQueueWebView = DispatchQueue(label: "DebugServicePlugin.webView")

  init() {
    DispatchQueue.main.async { [weak self] in
      self?.webView = WKWebView(frame: CGRect.zero)
      self?.webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] result, _ in
        if let userAgent = result as? String {
          self?.userAgent = userAgent
        } else {
          self?.userAgent = ""
        }
      })
    }
  }

  func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
    var mRq = request

    let bundle = Bundle.main.bundleIdentifier ?? ""

    // 0 -> WavesSDKVersionNumber
    let requestUserAgent = "\(userAgent) WavesSDK/\(0) DeviceId/\(WavesDevice.uuid) AppId/\(bundle)"

    mRq.setValue(requestUserAgent, forHTTPHeaderField: "User-Agent")

    print(mRq)

    return mRq
  }

  /// Called immediately before a request is sent over the network (or stubbed).
  func willSend(_: RequestType, target _: TargetType) {

  }

  /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
  func didReceive(_: Result<Moya.Response, MoyaError>, target _: TargetType) {

  }

  /// Called to modify a result before completion.
  func process(_ result: Result<Moya.Response, MoyaError>, target _: TargetType) -> Result<Moya.Response, MoyaError> {

    return result
  }
}
