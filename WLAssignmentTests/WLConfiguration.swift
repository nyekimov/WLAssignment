//
//  WLConfiguration.swift
//  WLAssignmentTests
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import WLAssignment
import Mockingjay

class WLConfiguration: QuickConfiguration {
    static let DEFAULT_TIMEOUT = TimeInterval(10)
    static let LONG_TIMEOUT    = TimeInterval(20)

    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            // Stub network calls
            MockingjayProtocol.addStub(matcher: everything, builder: http(404))
        }
    }
}
