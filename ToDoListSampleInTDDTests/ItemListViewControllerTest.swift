//
//  ItemListViewControllerTest.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import XCTest
@testable import ToDoListSampleInTDD

class ItemListViewControllerTest: XCTestCase {
    var mock:MockDataSource!
    var sut:ItemListViewController!
    
    override func setUp() {
        mock =  MockDataSource()
        sut = ItemListViewController(dataProvider: mock)
    }

    func test_TableViewIsNotNilAfterViewDid() {
        
         sut = ItemListViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_LoadViewSetstableViewDataSource() {
       
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.tableView.dataSource is MockDataSource)
    }
    
    func test_LoadView_SetsTableViewDelegate() {
        sut.loadViewIfNeeded()

        XCTAssertTrue(sut.tableView.delegate is MockDataSource)
    }
    
    func test_InitialVC_HasAddBarButtonWithSelfAsTarger(){
        sut.loadViewIfNeeded()
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func test_AddItem_Presents_AddItemViewController() {
        sut = ItemListViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
          window.makeKeyAndVisible()
          window.rootViewController = sut
        
        _ = sut.view
                
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
      
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is ToDoInputViewController)
    }
    
    func test_AddItem_PresentsAddItemViewController(){
        sut = ItemListViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
          window.makeKeyAndVisible()
          window.rootViewController = sut
        
        _ = sut.view
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)

        
        let vc = sut.presentedViewController as! ToDoInputViewController
        
        XCTAssertNotNil(vc)
    }

}


class MockDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
