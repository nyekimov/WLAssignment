//
//  Testing+Rx.swift
//  WLAssignmentTests
//
//  Created by Nick Yekimov on 3/25/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxTest

extension Observable {
    var firstEvent: Element? {
        return (try? self.toBlocking().first()).flatMap { $0 }
    }
}
extension Driver {
    var firstEvent: Element? {
        return (try? self.toBlocking().first()).flatMap { $0 }
    }
}
extension TestableObserver {
    var eventArray: [ElementType] {
        return events.flatMap { $0.value.element }
    }
    var firstEvent: ElementType? {
        return events.first?.value.element
    }
    var lastEvent: ElementType? {
        return events.last?.value.element
    }
}
