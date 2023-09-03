//
//  SceneCoordinatorType.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/30.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType{
    @discardableResult
    func transition(to scene:Scene, using style:TransitionStyle, animated:Bool) -> Completable
    
    @discardableResult
    func close(animated:Bool) -> Completable
}
