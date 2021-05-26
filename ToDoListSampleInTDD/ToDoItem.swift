//
//  ToDoItem.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import CoreLocation

struct ToDoItem : Equatable {
    
    let title: String
    let itemDescription: String? 
    let timestamp: Double?
    let location: Location?
    
    init(title: String,
         itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil){
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
}

func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    if lhs.location?.name != rhs.location?.name {
        return false
    }
    return true
}
