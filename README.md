# WLAssignment

A simple viewer of Walmart test products

----------------------------------------------------------------------------

[Cocoapods](https://cocoapods.org/) tool is used for the dependency management. If you don't have it, [install first](https://guides.cocoapods.org/using/getting-started.html#getting-started). Then execute a command line in the terminal `pod install` and open `WLAssignment.xcworkspace`.

The application is based on MVVC architecture. There is a product list table view controller driving table cells with products. `UIStackView`s are used in the table view's table cells for the UI scalability across screens with different wide. When a product is selected, product detail view controller opens and displays product details.

The table view is managed reactively by [RxSwift suite](https://github.com/RxSwiftCommunity).

[R.swift](https://github.com/mac-cain13/R.swift) is used to get strong references to the resources such as storyboards, nibs, and images.

[Alamofire](https://github.com/Alamofire/Alamofire) is used for the HTTP networking.

[Kingfisher](https://github.com/onevcat/Kingfisher) is used for asynchronous image downloading and caching.

[SwiftLint](https://github.com/realm/SwiftLint) is used to enforce Swift style and conventions, loosely based on [GitHub's Swift Style Guide](https://github.com/github/swift-style-guide).

The project includes a target `WLAssignmentTests` with unit tests. The product list network request and the product list model view are tested as they contain most of the app business logic.

[Quick](https://github.com/Quick/Quick), [RxNimble](https://github.com/RxSwiftCommunity/RxNimble) and [RxTest](https://github.com/ReactiveX/RxSwift/tree/master/RxTest) are used to simplify reactive testing.

[Mockingjay](https://github.com/kylef/Mockingjay) is used for stubbing HTTP requests.

----------------------------------------------------------------------------
