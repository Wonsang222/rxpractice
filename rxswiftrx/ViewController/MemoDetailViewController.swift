//
//  MemoDetailViewController.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/29.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController:UIViewController, ViewModelBindableType{
    
     
    @IBOutlet weak var contentTableView: UITableView!
    
    
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    var viewModel: MemoDetailViewModel!
    

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: contentTableView.rx.items){ tableview, row, value in
                switch row {
                case 0:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { (vc, _) in
                let memo = vc.viewModel.memo.content
                
                let activity = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                vc.present(activity, animated: true)
            }
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
        
        

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
