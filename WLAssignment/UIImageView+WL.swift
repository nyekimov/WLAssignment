//
//  UIImageView+WL.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/25/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    public func image(from urlString: String) {
        guard let url = URL(string: urlString) else {
            image = nil
            return
        }
        kf.setImage(with: url)
    }
}
