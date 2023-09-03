//
//  MemoListViewController.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/29.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController:UIViewController, ViewModelBindableType{
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var viewModel: MemoListViewModel!
    
    func bindViewModel() {
        print("3")
        print(Thread.isMainThread)
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        
        
        addButton.rx.action = viewModel.makeCreationAction()
        
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .withUnretained(self)
            .do(onNext: {vc, idx in
                vc.listTableView.deselectRow(at: idx.1, animated: true)
            })
                .map{ $1.0}
                .bind(to: viewModel.detailACtion.inputs)
                .disposed(by: rx.disposeBag)
                
        listTableView.rx.modelDeleted(Memo.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
