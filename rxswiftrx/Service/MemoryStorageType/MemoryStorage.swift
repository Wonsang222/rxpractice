//
//  MemoryStorage.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/08/28.
//

import Foundation
import RxSwift

class MemoryStorage:MemoStorageType{
    private var list = [
        Memo(content: "hello rxswift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "lorem ipsum", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    private lazy var store = BehaviorSubject<[MemoSectionModel]> (value: [sectionModel])
    
    @discardableResult
    func create(content: String) -> RxSwift.Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        return store
    }
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}){
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
            
            store.onNext([sectionModel])
        }
        
        return Observable.just(updated)
    }
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}){
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
        
        
    }
    

}
