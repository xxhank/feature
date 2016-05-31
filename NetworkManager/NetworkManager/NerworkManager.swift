//
//  NerworkManager.swift
//  NetworkManager
//
//  Created by wangchaojs02 on 16/5/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import Alamofire

func SSLogInfo(message: AnyObject, FILE: String = #file, LINE: Int = #line, FUNCTION: String = #function) {
    print("\((FILE as NSString).lastPathComponent):\(LINE) \(FUNCTION) > \(message)")
}

protocol CancelableRequest: class {
    func cancel()
}

class WeakRequest {
    weak var request: CancelableRequest?
    deinit {
        SSLogInfo("")
    }

    required init(request: CancelableRequest) {
        self.request = request
    }
}

extension Request: CancelableRequest {
}

protocol NetworkRequest {
    var identifier: String { get }
    var url: String { get }
    var parameters: [String: AnyObject] { get }
    var headers: [String: String] { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension NetworkRequest {
    var identifier: String {
        return "\(self.dynamicType)"
    }

    var parameters: [String: AnyObject] {
        return [:]
    }
    var headers: [String: String] {
        return [:]
    }
    var parameterEncoding: ParameterEncoding {
        return ParameterEncoding.URL
    }
}

class NerworkManager: NSObject {
    static let shared = NerworkManager()
    let UUID = NSUUID()
    var requests = [String: AnyObject]()
    let sharedParameters: [String: AnyObject] = ["r": NSDate().timeIntervalSince1970]

    func fetch(request: NetworkRequest) -> String {
        cancel(request.identifier)
        let manager = Manager.sharedInstance
        var mixedParameters = [String: AnyObject]()
        sharedParameters.forEach { (key, value) in
            mixedParameters[key] = value
        }

        request.parameters.forEach { (key, value) in
            mixedParameters[key] = value
        }

        let handler = manager.request(.GET,
            request.url,
            parameters: mixedParameters,
            encoding: request.parameterEncoding,
            headers: request.headers)
            .response { [weak self](request, response, data, error) in
                if let request = request {
                    let token = "\(unsafeAddressOf(request))"
                    self?.requests.removeValueForKey(token)
                } else {
                    SSLogInfo("request not exist")
                }
                if let error = error {
                    if error.code == NSURLErrorCancelled {
                        SSLogInfo("Canceled")
                    } else {
                        SSLogInfo("\(error)")
                    }
                } else {
                    SSLogInfo("got data form \(request!)")
                }
        }
        handler.resume()
        let token = "\(unsafeAddressOf(handler))"
        requests[token] = WeakRequest(request: handler)
        if !request.identifier.isEmpty {
            requests[request.identifier] = WeakRequest(request: handler)
        }
        return token
    }

    func cancel(token: String) {
        guard !token.isEmpty else { return }
        if let weakRequest = requests[token] as? WeakRequest {
            weakRequest.request?.cancel()
            self.requests.removeValueForKey(token)
        }
    }
}
