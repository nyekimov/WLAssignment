//
//  ProductDetailVC.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/25/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Private Properties
    private var viewModel: ProductDetailViewModel!
    private var product: Product {
        return viewModel.product
    }

    // MARK: - Static init
    static func createWith(viewModel: ProductDetailViewModel) -> ProductDetailVC {
        let vc = R.storyboard.main.productDetailVC()!
        vc.viewModel = viewModel
        return vc
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Product Details", comment: "Product Details")
        nameLabel.text = product.name
        let translatedRating = String.localizedStringWithFormat(NSLocalizedString("%.01f out of 5 stars(%i)", comment: "%f out of 5 stars %i"), product.reviewRating, product.reviewCount)
        ratingLabel.text = translatedRating
        if product.inStock {
            availabilityLabel.text = NSLocalizedString("In Stock", comment: "In Stock")
            availabilityLabel.textColor = .green
        } else {
            availabilityLabel.text = NSLocalizedString("Out of Stock", comment: "Out of Stock")
            availabilityLabel.textColor = .red
        }
        productImageView.image(from: product.imageURLString)
        if let desc = product.longDescription {
            setDescText(desc)
        } else if let desc = product.shortDescription {
            setDescText(desc)
        }
        priceLabel.text = product.price
    }

    private func setDescText(_ desc: String) {
        if let data = desc.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            let text = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            descriptionLabel.attributedText = text
        }
    }
}
