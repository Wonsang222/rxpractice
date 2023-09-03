//
//  ViewModelBindableType.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/29.
//

import UIKit

protocol ViewModelBindableType{
    associatedtype ViewModelType
    
    var viewModel:ViewModelType! {get set}
    func bindViewModel()
}

extension ViewModelBindableType where Self:UIViewController{
    mutating func bind(viewmodel:Self.ViewModelType){
        print("2")
        print(Thread.isMainThread)
        self.viewModel = viewmodel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
