import Quick
import Nimble
import RxNimble
import RxSwift
import RxDataSources
@testable import WLAssignment
import RxTest

class ProductsListViewModelSpec: QuickSpec {
    override func spec() {
        describe("ProductsListViewModel") {
            var sut: ProductsListViewModel!
            var mockProductsListService: ProductsListServiceMock!
            var mockResponse: ProductsListRequestResponse!
            var products: [Product]!
            var scheduler: TestScheduler!
            var initialLoadingObserver: TestableObserver<Bool>!
            var initialLoadingSubscription: Disposable!
            var loadingMoreObserver: TestableObserver<Bool>!
            var loadingMoreSubscription: Disposable!
            var errorObserver: TestableObserver<Error>!
            var errorSubscription: Disposable!

            beforeEach {
                let item1 = Product(id: "id1", name: "name1", shortDescription: nil, longDescription: nil, price: "$100", imageURLString: "bla", reviewRating: 0.0, reviewCount: 0, inStock: true)
                let item2 = Product(id: "id2", name: "name2", shortDescription: nil, longDescription: nil, price: "$100", imageURLString: "bla", reviewRating: 0.0, reviewCount: 0, inStock: true)
                products = [item1, item2]
                scheduler = TestScheduler(initialClock: 0)
            }

            context("when success") {

                beforeEach {
                    let item1 = Product(id: "id1", name: "name1", shortDescription: nil, longDescription: nil, price: "$100", imageURLString: "bla", reviewRating: 0.0, reviewCount: 0, inStock: true)
                    let item2 = Product(id: "id2", name: "name2", shortDescription: nil, longDescription: nil, price: "$100", imageURLString: "bla", reviewRating: 0.0, reviewCount: 0, inStock: true)
                    products = [item1, item2]
                    let productsList = ProductsList(products: products,
                                                    totalProductsCount: 10,
                                                    pageNumber: 1,
                                                    pageSize: 30,
                                                    httpStatus: 200)
                    mockResponse = ProductsListRequestResponse.products(productsList)
                    mockProductsListService = ProductsListServiceMock(response: mockResponse)
                    sut = ProductsListViewModel(productsListService: mockProductsListService)

                    initialLoadingObserver = scheduler.createObserver(Bool.self)
                    initialLoadingSubscription = sut.initialLoadingDone.asObservable()
                        .bind(to: initialLoadingObserver)
                    loadingMoreObserver = scheduler.createObserver(Bool.self)
                    loadingMoreSubscription = sut.loadingMoreData.asObservable()
                        .bind(to: loadingMoreObserver)
                }
                afterEach {
                    scheduler.scheduleAt(1000) {
                        initialLoadingSubscription.dispose()
                        loadingMoreSubscription.dispose()
                        errorSubscription.dispose()
                    }
                }

                it("returns products") {
                    sut.loadProducts()

                    let event = sut.products.firstEvent
                    expect(event).toNot(beNil())
                    let products = event?.first?.items
                    expect(products?.count) == 2
                }

                context("initialLoadingDone") {
                    it("is false") {
                        let event = initialLoadingObserver.firstEvent ?? false
                        // nil means request isn't done yet
                        expect(event) == false
                    }
                    it("is true") {
                        sut.loadProducts()
                        let event = initialLoadingObserver.lastEvent ?? false
                        expect(event) == true
                    }
                }

                context("loadingMoreData") {
                    it("is false") {
                        sut.loadProducts()

                        let event = loadingMoreObserver.firstEvent ?? false
                        // request is done for first page
                        expect(event) == false
                    }
                    it("fires when page synced") {
                        // syncs first page and set page to 2
                        sut.loadProducts()
                        // syncs second page
                        sut.loadProducts()

                        let lastEvent = loadingMoreObserver.lastEvent ?? false
                        expect(lastEvent) == false
                    }
                }
            }
            context("when error") {
                beforeEach {
                    mockResponse = ProductsListRequestResponse.error(WLError.default)
                    mockProductsListService = ProductsListServiceMock(response: mockResponse)
                    sut = ProductsListViewModel(productsListService: mockProductsListService)

                    errorObserver = scheduler.createObserver(Error.self)
                    errorSubscription = sut.error.asObservable()
                        .bind(to: errorObserver)
                }
                afterEach {
                    scheduler.scheduleAt(1000) {
                        errorSubscription.dispose()
                    }
                }
                it("returns error") {
                    sut.loadProducts()

                    let event = errorObserver.lastEvent
                    expect(event).toNot(beNil())
                }
            }
        }
    }
}
