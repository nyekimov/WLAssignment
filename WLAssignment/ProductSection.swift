//
//  ProductSection.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct ProductSection {
    var header: String
    var items: [Product]
}
extension ProductSection: SectionModelType {
    typealias Item = Product
    init(original: ProductSection, items: [Item]) {
        self = original
        self.items = items
    }
}
