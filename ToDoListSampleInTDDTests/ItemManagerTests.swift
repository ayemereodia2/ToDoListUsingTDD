//
//  ItemManagerTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 31/05/2021.
//

import XCTest
import Foundation

class ItemManagerTests : XCTestCase {
    
    var itemManager:ItemManager?
    override func setUp() {
        itemManager = ItemManager()
    }
    
    func test_ToDoItemsGetsSerialized(){
        itemManager = ItemManager()
        let firstItem = ToDoItem(title: "Foo")
        itemManager?.add(firstItem)
        let secondItem = ToDoItem(title: "Boo")
        itemManager?.add(secondItem)
        //save to disk
        NotificationCenter.default.post(
            name: UIApplication.willResignActiveNotification, object: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.item(at: 0), firstItem)
        
        XCTAssertEqual(itemManager?.item(at: 1), secondItem)
        
        
    }
    
    override func tearDown() {
        itemManager?.removeAll()
        itemManager = nil
    }
}
