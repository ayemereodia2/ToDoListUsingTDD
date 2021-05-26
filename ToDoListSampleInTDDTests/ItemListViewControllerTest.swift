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

}


class MockDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
