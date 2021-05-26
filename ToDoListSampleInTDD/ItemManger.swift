//
//  ItemsManger.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import Foundation

class ItemManager {
    
    var toDoCount:Int{ return toDoItems.count }
    var doneCount:Int { return doneItems.count }
    
    private var toDoItems: [ToDoItem] = [] 
    private var doneItems: [ToDoItem] = []
    
    func add(_ item: ToDoItem) { 
        //toDoCount += 1
        toDoItems.append(item)
    }
    func item(at index: Int) -> ToDoItem { 
        return toDoItems[index]
    }
    
    func checkItem(at index: Int) { 
//           toDoCount -= 1
//           doneCount += 1
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
        
}

