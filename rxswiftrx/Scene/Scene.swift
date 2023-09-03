//
//  Scene.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/29.
//

import UIKit

enum Scene{
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self{
        case .list(let memoListViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError()}
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError()
                
            }
            
            print("1")
            print(Thread.isMainThread)
//            listVC.bind(viewmodel: memoListViewModel)
//
            DispatchQueue.main.async {
                listVC.bind(viewmodel: memoListViewModel)
            }

            return nav
            
        case .detail(let memoDetailViewModel):
            
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                detailVC.bind(viewmodel: memoDetailViewModel)
            }
            
            
            return detailVC
        case .compose(let memoComposeViewModel):
            
            guard let nav = storyboard.instantiateViewController(withIdentifier: "composeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var compseVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                compseVC.bind(viewmodel: memoComposeViewModel)
            }
          
            
            return nav
        }
    }
}
