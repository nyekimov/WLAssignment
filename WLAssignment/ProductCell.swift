//
//  ProductCell.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!

    override func awakeFromNib() {
    }

    func configure(with product: Product) {
        priceLabel.text = product.price
        nameLabel.text = product.name
        productImageView.image(from: product.imageURLString)

        let translatedRating = String.localizedStringWithFormat(NSLocalizedString("%.01f out of 5 stars(%i)", comment: "%f out of 5 stars %i"), product.reviewRating, product.reviewCount)
        ratingLabel.text = translatedRating
        if product.inStock {
            availabilityLabel.text = NSLocalizedString("In Stock", comment: "In Stock")
            availabilityLabel.textColor = .green
        } else {
            availabilityLabel.text = NSLocalizedString("Out of Stock", comment: "Out of Stock")
            availabilityLabel.textColor = .red
        }
    }
}
