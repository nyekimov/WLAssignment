//
//  ProductsListViewModel.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

protocol ProductsListViewModelProtocol {
    var products: Driver<[ProductSection]> { get }
    var error: Driver<Error> { get }
    var loadingMoreData: Driver<Bool> { get }
    var initialLoadingDone: Driver<Bool> { get }
    var totalResultsCount: Int { get }
    func loadProducts()
}

class ProductsListViewModel: ProductsListViewModelProtocol {
    // MARK: - Stored Properties
    var products: Driver<[ProductSection]> {
        return _products.asDriver().map { [ProductSection(header: "", items: $0)]}
    }
    var error: Driver<Error> {
        return _error.asDriver(onErrorJustReturn: WLError.default)
    }
    var loadingMoreData: Driver<Bool> {
        return _loadingMoreData.asDriver(onErrorJustReturn: false)
    }
    var initialLoadingDone: Driver<Bool> {
        return _initialLoadingDone.asDriver(onErrorJustReturn: false)
    }
    var totalResultsCount: Int {
        return _totalResultsCount
    }

    // MARK: - Private Properties
    private var _products: Variable<[Product]> = Variable([])
    private var _error = PublishSubject<Error>()
    private var _loadingMoreData = PublishSubject<Bool>()
    private let productsListService: ProductsListServiceProtocol
    private var page = 1
    private var _initialLoadingDone = PublishSubject<Bool>()
    private var _totalResultsCount = 0

    // MARK: - Init with dependency injection
    init(productsListService: ProductsListServiceProtocol) {
        self.productsListService = productsListService
    }

    // MARK: - Methods
    func loadProducts() {
        if page > 1 {
            _loadingMoreData.onNext(true)
        }
        productsListService.requestProductsList(for: page) { [weak self] response in
            guard let strongSelf = self else { return }
            if strongSelf.page == 1 {
                strongSelf._initialLoadingDone.onNext(true)
            }
            strongSelf._loadingMoreData.onNext(false)

            switch response {
            case .error(let error):
                print("ProductsListViewModel.requestData: error - \(error.localizedDescription)")
                strongSelf._error.onNext(error)

            case .products(let productsList):
                strongSelf._totalResultsCount = productsList.totalProductsCount
                let combined = strongSelf._products.value + productsList.products
                strongSelf.page = productsList.pageNumber + 1
                strongSelf._products.value = combined
            }
        }
    }
}
