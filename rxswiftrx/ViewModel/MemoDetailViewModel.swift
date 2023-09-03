//
//  MemoDetailViewModel.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx


class MemoDetailViewModel:CommonViewModel{
    
    var memo:Memo
    
    private var formatter:DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    var contents:BehaviorSubject<[String]>
    
    init(memo:Memo, title:String, sceneCoordinator:SceneCoordinatorType, storage:MemoStorageType){
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage as! MemoryStorage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map { _ in }
    }
    
    func performUpdate(memo:Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .do(onNext: {self.memo = $0})
                .map{[$0.content, self.formatter.string(from: $0.insertDate)]}
                .bind(onNext: { self.contents.onNext($0)})
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction{
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable()
                .map { _ in }
        }
    }
    
    func makeDeleteAction() -> CocoaAction{
        return Action { input in
            self.storage.delete(memo: self.memo)
            
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map {  _ in }
        }
    }
}