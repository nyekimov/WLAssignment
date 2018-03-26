import Quick
import Nimble
import Mockingjay
@testable import WLAssignment
import Alamofire

class ProductsListRequestSpec: QuickSpec {
    override func spec() {
        describe("ProductsListRequest") {
            var bundle: Bundle {
                return Bundle(for: type(of: self))
            }
            var sut: ProductsListRequest!

            beforeEach {
                sut = ProductsListRequest(pageNumber: 1)
            }

            it("uses correct url components") {
                expect(sut.url).toNot(beNil())
                expect(sut.path) == "/walmartproducts/\(sut.apiKey)/1/30"
                expect(sut.scheme) == "https"
                expect(sut.host) == "walmartlabs-test.appspot.com"
            }

            it("doesn't use parameters") {
                expect(sut.parameters).to(beNil())
            }

            it("uses correct http method") {
                expect(sut.method) == HTTPMethod.get
            }

            context("when request called") {
                context("when failure") {

                    it("returns failure with error to caller on error code") {
                        Nimble.waitUntil(timeout: WLConfiguration.DEFAULT_TIMEOUT) { done in
                            self.stub(uri(sut.url!.absoluteString), http(404))
                            sut.request { response in
                                switch response {
                                case .error(let error):
                                    expect(error).notTo(beNil())
                                case .products:
                                    fail()
                                    return
                                }

                                done()
                            }
                        }
                    }
                    it("returns failure with error to caller on wrong payload data") {
                        Nimble.waitUntil(timeout: WLConfiguration.DEFAULT_TIMEOUT) { done in
                            let data = GetResponse.get("EmptyResponse", ext: .JSON, inBundle: bundle)
                            self.stub(uri(sut.url!.absoluteString), json(data))

                            sut.request { response in
                                switch response {
                                case .error(let error):
                                    expect(error).notTo(beNil())
                                case .products:
                                    fail()
                                    return
                                }
                                done()
                            }
                        }
                    }
                }
                context("when success") {
                    beforeEach {
                        let data = GetResponse.get("ProductsListSample", ext: .JSON, inBundle: bundle)
                        self.stub(uri(sut.url!.absoluteString), json(data))
                    }

                    it("returns product list to caller") {
                        Nimble.waitUntil(timeout: WLConfiguration.DEFAULT_TIMEOUT) { done in
                            sut.request { response in
                                switch response {
                                case .error:
                                    fail()
                                    return
                                case .products(let productsList):
                                    expect(productsList.products.count) == 1

                                    let first = productsList.products.first
                                    expect(first?.name) == "Samsung 50\" Class 4K Ultra HD LED Smart TV - UN50JU650DFXZA"
                                    expect(first?.id) == "0150f9b5-8918-4fd1-92b3-fc032cc6c684"
                                    expect(first?.price) == "$928.00"
                                    expect(first?.imageURLString) == "https://walmartlabs-test.appspot.com/images/image5.jpeg"
                                    expect(first?.reviewRating) == 4.5
                                    expect(first?.reviewCount) == 2
                                    expect(first?.inStock) == true
                                    expect(first?.shortDescription) == "bla"
                                    expect(first?.longDescription) == "bla bla"
                                }

                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
