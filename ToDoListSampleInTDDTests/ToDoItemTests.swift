//
//  ToDoItemTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 31/05/2021.
//

import XCTest

class ToDoItemTests: XCTestCase {
    
    func test_HasPlistPropertyDictionary(){
        let item = ToDoItem(title: "Foo")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is [String:Any])
    }
    
    func test_CanBeCreated_FromPlistDictionary(){
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "Bar", itemDescription: "description", timestamp: 1.0, location: location)
        let dict = item.plistDict
        
        let createdItem = ToDoItem(dict:dict)
        
        XCTAssertEqual(item, createdItem)
    }
}
