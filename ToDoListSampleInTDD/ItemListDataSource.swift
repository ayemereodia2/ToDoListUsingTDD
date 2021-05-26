//
//  ItemListDataSource.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import UIKit

 class ItemListDataSource :NSObject, UITableViewDataSource,UITableViewDelegate {
    
    var itemManager:ItemManager?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemManager = itemManager else { return 0}
        guard let section = Section(rawValue: section) else { fatalError()}
        var numberOfRows = 0
        
        switch section {
        case .toDo:
            numberOfRows = itemManager.toDoCount 
        case .done:
            numberOfRows = itemManager.doneCount 
        
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        guard let itemManager = itemManager else {
            fatalError()
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        let item:ToDoItem
        
        switch section {
        case .toDo:
            item = itemManager.item(at: indexPath.row)
        case .done:
            item = itemManager.doneItem(at: indexPath.row)
            
        }
        
        cell.configCell(with: item)
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        var buttonTitle:String
        switch section {
        case .toDo:
            buttonTitle = "Check"
        case .done:
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //itemManager?.checkItem(at: indexPath.row)
        
        guard let itemManager = itemManager else {
            fatalError()
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .toDo:
            itemManager.checkItem(at: indexPath.row)
        case .done:
            itemManager.uncheckItem(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    
    
}

enum Section : Int {
    case toDo
    case done
}
