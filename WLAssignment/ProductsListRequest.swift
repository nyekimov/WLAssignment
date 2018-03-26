//
//  ProductsListRequest.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation

enum ProductsListRequestResponse {
    case products(ProductsList)
    case error(WLError)
}
typealias ProductsListResponseClosure = ((ProductsListRequestResponse) -> Void)

class ProductsListRequest: WLAPIRequest {
    // MARK: - Properties
    let pageNumber: Int
    let pageSize: Int
    override var path: String {
        return "/walmartproducts/\(apiKey)/\(pageNumber)/\(pageSize)"
    }

    // MARK: - Init
    init(pageNumber: Int, pageSize: Int = 30) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }

    func request(completion: @escaping ProductsListResponseClosure) {
        guard let url = url else {
            completion(.error(.invalidURL))
            return
        }
        WLAPIClient.request(url: url, method: method) { response in
            switch response {
            case .data(let data, _):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let productsList = try decoder.decode(ProductsList.self, from: data)
                    guard 200 ..< 300 ~= productsList.httpStatus else {
                        completion(.error(.httpInternalError))
                        return
                    }
                    completion(.products(productsList))
                } catch {
                    print("parsing error: \(error)")
                    completion(.error(.payloadInvalidData))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
