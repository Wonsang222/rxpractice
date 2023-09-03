//
//  CoreDataStorage.swift
//  rxswiftrx
//
//  Created by 황원상 on 2023/09/02.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

class CoreDataStorage:MemoStorageType{
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "rxswiftrx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @discardableResult
    func create(content: String) -> RxSwift.Observable<Memo> {
        let memo  = Memo(content: content)
        do{
            try mainContext.rx.update(memo)
            return Observable.just(memo)
        } catch{
            return Observable.error(error)
        }
    }
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map{result in [MemoSectionModel(model: 0, items: result)]}
    }
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        do{
            try mainContext.rx.update(updated)
            return Observable.just(updated)
        }catch{
            return Observable.error(error)
        }
    }
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        do{
            try mainContext.rx.delete(memo)
            return Observable.just(memo)
        }catch{
            return Observable.error(error)
        }
    }

}

