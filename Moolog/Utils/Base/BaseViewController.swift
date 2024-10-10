//
//  BaseViewController.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .black
        
        bind()
        setHierarchy()
        setConstraints()
    }
    
    func bind() { }
    
    func setHierarchy() { }
    
    func setConstraints() { }
}
