//
//  WLAPIClient.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import Alamofire

typealias RestReponseHeaders = [AnyHashable: Any]
typealias ResponseClosure = ((_ response: Response) -> Void)

enum Response {
    case data(Data, RestReponseHeaders)
    case error(WLError)
}

struct WLAPIClient {
    private static let queue = DispatchQueue(label: "network queue", qos: .default)

    static func request(url: URL, method: HTTPMethod, callback: @escaping ResponseClosure) {
        let session = SessionManager(configuration: configuration)
        let id = SessionPool.default.add(session)
        session.request(url, method: method).validate().responseData(queue: queue) { [sessionId = id] response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    callback(.error(.payloadInvalidData))
                    return
                }
                print("data: \n \(data.debugDescription) \n")
                print("response: \n \(response.response?.debugDescription ?? "") \n")
                callback(.data(data, response.response?.allHeaderFields ?? [:]))
            case .failure(let error):
                print("error - > \n    \(error.localizedDescription) \n")
                callback(.error(.systemError(error)))
            }
            SessionPool.default.remove(sessionId)
        }
    }

    private static var configuration: URLSessionConfiguration {
        var headers = SessionManager.defaultHTTPHeaders
        headers["Accept"] = "application/json"
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.httpAdditionalHeaders = headers
        return configuration
    }
}

// MARK: - Session management
private class SessionPool {
    // singleton
    static let `default` = SessionPool()
    private init() {}

    private var pool: [AnyHashable: SessionManager] = [:]
    private let queue = DispatchQueue(label: "Session pool queue")

    func add(_ session: SessionManager) -> String {
        let uuid = Date().description + UUID().uuidString
        queue.sync {
            pool[uuid] = session
        }
        return uuid
    }

    func remove(_ id: String) {
        queue.sync {
            pool[id] = nil
        }
    }
}
