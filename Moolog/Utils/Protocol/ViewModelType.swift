//
//  ViewModelType.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/10/24.
//

import Foundation

import RxSwift

protocol ViewModelType: AnyObject {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
