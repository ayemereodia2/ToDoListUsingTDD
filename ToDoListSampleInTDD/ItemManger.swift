//
//  ItemsManger.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import UIKit

class ItemManager: NSObject {
    
    var toDoCount:Int{ return toDoItems.count }
    var doneCount:Int { return doneItems.count }
    
    var toDoPathUrl:URL {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentUrl = fileUrl.first else {
            print("Document url could not be found")
            fatalError()
        }
        return documentUrl.appendingPathComponent("toDoItems.plist")
    }
    
    private var toDoItems: [ToDoItem] = [] 
    private var doneItems: [ToDoItem] = []
    
    func add(_ item: ToDoItem) { 
        toDoItems.append(item)
    }
    func item(at index: Int) -> ToDoItem { 
        return toDoItems[index]
    }
    
    func checkItem(at index: Int) { 
        print(toDoItems.count)
      let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func uncheckItem(at index:Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
        
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    } 
    
   override init() {
    super.init()
    
    NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
    if let nsToDoItems = NSArray(contentsOf: toDoPathUrl) {
        for dict in nsToDoItems {
            if let todoItem = ToDoItem(dict: dict as! [String:Any]) {
                toDoItems.append(todoItem)
            }
        }
    }
  }
    
    func removeAll() {
        toDoItems = []
        doneItems = []
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    @objc func save() {
        let nsToDoItems = toDoItems.map {$0.plistDict}
        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: toDoPathUrl)
            return
        }
        do{
            let plistDate = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0))
            try plistDate.write(to: toDoPathUrl, options: Data.WritingOptions.atomic)
            
        }catch let error {
            print(error)
        }
    }
        
}

@objc protocol ItemManagerSettable {
    var itemManager:ItemManager? { get set}
}

