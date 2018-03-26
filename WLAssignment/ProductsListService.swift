//
//  ProductsListService.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation

protocol ProductsListServiceProtocol {
    func requestProductsList(for page: Int, completion: @escaping ProductsListResponseClosure)
}

struct ProductsListService: ProductsListServiceProtocol {
    func requestProductsList(for page: Int, completion: @escaping ProductsListResponseClosure) {
        ProductsListRequest(pageNumber: page).request(completion: completion)
    }
}
