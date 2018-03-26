//
//  WLAPIRequest.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestProtocol {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [(key: String, value: String)]? { get }
}

class WLAPIRequest: RequestProtocol {
    // MARK: - Properties
    let scheme = "https"
    let host = "walmartlabs-test.appspot.com"
    let mainPath = "/_ah/api/walmart/v1"
    let apiKey = "f29b2358-3e89-4fe9-ba31-1aeda1120139"

    // MARK: - Stored Properties
    var path: String {
        return ""
    }
    var method: HTTPMethod {
        return .get
    }
    var url: URL? {
        return urlComponents.url
    }
    var parameters: [(key: String, value: String)]? {
        return nil
    }

    /// Constructs url components
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = mainPath + path

        var queryItems: [URLQueryItem] = []
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        urlComponents.queryItems = queryItems
        return urlComponents
    }
}
