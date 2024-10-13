//
//  Reactive+.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import UIKit

import RxSwift

extension Reactive where Base: UIViewController {
    var viewWillAppear: RxSwift.Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:)))
            .map { _ in () }
    }

    var viewDidAppear: RxSwift.Observable<Void> {
        return sentMessage(#selector(base.viewDidAppear(_:)))
            .map { _ in () }
    }

    var viewWillDisappear: RxSwift.Observable<Void> {
        return sentMessage(#selector(base.viewWillDisappear(_:)))
            .map { _ in () }
    }

    var viewDidDisappear: RxSwift.Observable<Void> {
        return sentMessage(#selector(base.viewDidDisappear(_:)))
            .map { _ in () }
    }
}
