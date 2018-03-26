//
//  GetResponse.swift
//  WLAssignmentTests
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation

class GetResponse {
    enum Extension: String { case JSON, DATA}

    class func get(_ filename: String, ext: Extension, inBundle bundle: Bundle) -> Any {
        guard let url = bundle.url(forResource: filename, withExtension: ext.rawValue.lowercased()) else { fatalError() }

        switch ext {
        case .JSON:
            guard let data = try? Data(contentsOf: url) else { fatalError() }

            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                fatalError(error.localizedDescription)
            }
        case .DATA:
            guard let data = try? Data(contentsOf: url) else { fatalError() }
            return data
        }
    }
}
