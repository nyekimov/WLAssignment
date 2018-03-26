//
//  ProductsList.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation

struct ProductsList: Codable {
    // MARK: - Properties
    let products: [Product]
    let totalProductsCount: Int
    let pageNumber: Int
    let pageSize: Int
    let httpStatus: Int
}

// MARK: - Coding keys
extension ProductsList {
    enum CodingKeys: String, CodingKey {
        case products
        case totalProductsCount = "totalProducts"
        case pageNumber
        case pageSize
        case httpStatus = "status"
    }
}
