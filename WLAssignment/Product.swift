//
//  Product.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation

struct Product: Codable {

    // MARK: - Properties
    let id: String
    let name: String
    let shortDescription: String?
    let longDescription: String?
    let price: String
    let imageURLString: String
    let reviewRating: Double
    let reviewCount: Int
    let inStock: Bool
}

// MARK: - Coding keys
extension Product {
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name = "productName"
        case shortDescription
        case longDescription
        case price
        case imageURLString = "productImage"
        case reviewRating
        case reviewCount
        case inStock
    }
}
