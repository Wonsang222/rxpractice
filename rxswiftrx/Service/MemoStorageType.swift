//
//  MemoStorageType.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/28.
//

import Foundation
import RxSwift

protocol MemoStorageType{
    @discardableResult
    func create(content:String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo:Memo, content:String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo:Memo) -> Observable<Memo>
    
}
