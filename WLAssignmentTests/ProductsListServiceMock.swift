//
//  ProductsListServiceMock.swift
//  WLAssignmentTests
//
//  Created by Nick Yekimov on 3/25/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
@testable import WLAssignment

struct ProductsListServiceMock: ProductsListServiceProtocol {
    let response: ProductsListRequestResponse!

    func requestProductsList(for page: Int, completion: @escaping ProductsListResponseClosure) {
        completion(response)
    }
}
