//
//  CommonViewModel.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel:NSObject{
    let title:Driver<String>
    
    let sceneCoordinator:SceneCoordinatorType
    let storage:MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
