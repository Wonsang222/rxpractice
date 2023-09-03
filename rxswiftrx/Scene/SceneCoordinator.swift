//
//  SceneCoordinator.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController{
    var sceneViewController:UIViewController{
        return self.children.last ?? self
    }
}

class SceneCoordinator:SceneCoordinatorType{
    
    private let bag = DisposeBag()
    
    private var window:UIWindow
    private var currentVC:UIViewController
    
    required init(window:UIWindow){
        self.window = window
        currentVC = window.rootViewController!
        
    }
    
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        let subject = PublishSubject<Never>()
        
        let target = scene.instantiate()
        
        switch style{
        case .root:
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case.push:
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: {coordinator, evt in
                    coordinator.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            subject.onCompleted()
        case.modal:
            currentVC.present(target, animated: true){
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
        }
        
        return subject.asCompletable()
        
        
    }
    
    func close(animated: Bool) -> RxSwift.Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController{
                self.currentVC.dismiss(animated: animated){
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            else if let nav = self.currentVC.navigationController{
                guard nav.popViewController(animated: animated) != nil else{
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!.sceneViewController
            }
            else{
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
    
    
}
