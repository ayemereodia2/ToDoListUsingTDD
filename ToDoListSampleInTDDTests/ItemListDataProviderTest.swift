//
//  ItemListDataProviderTest.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import XCTest
@testable import ToDoListSampleInTDD

class ItemListDataProviderTest: XCTestCase {
    
    var sut:ItemListDataSource!
    var controller:ItemListViewController!
    
    override func setUp() {
        self.sut = ItemListDataSource()
        self.controller = ItemListViewController()
        controller.dataProvider = sut
        controller.tableView.delegate = sut
        controller.loadViewIfNeeded()

        sut.itemManager = ItemManager()
    }

    func test_TableViewNumberOfSectionsIs2() {
        
//        controller.dataProvider = sut
//        
//        controller.loadViewIfNeeded()
        
        XCTAssertEqual(controller.tableView.numberOfSections, 2)
        
    }
    
    func test_NumberOfRows_InSection1_IsToDoCount() {
        
//        controller.dataProvider = sut
//        sut.itemManager = ItemManager()
//        controller.loadViewIfNeeded()
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 1)
        
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        controller.tableView.reloadData()
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_NumberOfRows_Section2_IsEqualToDoneCount() {
      
        //controller.loadViewIfNeeded()
        sut?.itemManager?.add(ToDoItem(title: "Foo"))
        sut.itemManager?.add(ToDoItem(title: "Bar"))
        sut.itemManager?.checkItem(at: 0)
        
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItem(at: 0)
        
        controller.tableView.reloadData()
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 1), 2)
        
    }
    
    func test_TableView_CellForRowAt_ReturnsItemsCell() {
        sut.itemManager = ItemManager()
        controller.dataProvider = sut
        controller.tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellId)
        controller.loadViewIfNeeded()

        sut?.itemManager?.add(ToDoItem(title: "Foo"))
        controller.tableView.reloadData()

        let cell = controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) 
        
        XCTAssertTrue(cell is ItemCell)
        
        //USING MOCKS
    }
    
    func test_TestCellForRow_DequeueCellFromTableView() {
        let mock = MockTableView()
        mock.dataSource = sut
        mock.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellId)
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        mock.reloadData()
        
        _ = mock.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mock.cellGotDequeued)
    }
    
    func test_CellForRow_CallsConfigCell() {
        let mock = MockTableView.mockTableView(with: sut)
    
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        mock.reloadData()
        
        let cell = mock.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.catchedItem!.title, "Foo")

    }
    
    func test_CellForRow_Section2_CallsConfigCellWithDoneItem() {
        let mock = MockTableView.mockTableView(with: sut)
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        sut.itemManager?.add(ToDoItem(title: "Bar"))
        
        sut.itemManager?.checkItem(at: 1)
        mock.reloadData()
        let cell = mock.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.catchedItem!.title, "Bar")

    }
    
    func test_DeleteButton_InFirstSection_ShowsTitleCheck() {
        let deleteButtonTitle = controller.tableView.delegate?.tableView?(controller.tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row:0, section:0))
        
        XCTAssertEqual(deleteButtonTitle, "Check")
    }
    
    func test_DeleteButton_InSecondSection_ShowsTitleUncheck(){
        let deleteButtonTitle = controller.tableView.delegate?.tableView?(controller.tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row:0,section: 1))
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
    
    func test_CheckingAnItem_ChecksItInTheItemDataManager(){
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        controller.tableView.dataSource?.tableView?(controller.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 1), 1)
    }
    
    func test_UncheckingAnItem_UncheckItInTheItemDataManager(){
        sut.itemManager?.add(ToDoItem(title: "First"))
        sut.itemManager?.checkItem(at: 0)
        controller.tableView.reloadData()
        
        controller.tableView.dataSource?.tableView?(controller.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 1), 0)
    }

}


extension ItemListDataProviderTest {
    
    class MockTableView: UITableView {
        
        var cellGotDequeued = false
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTableView(with dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            mockTableView.dataSource = dataSource
            return mockTableView
        }
    }
    
    class MockItemCell : ItemCell {
        
        var catchedItem:ToDoItem?
        
        override func configCell(with item:ToDoItem, checked:Bool){
            catchedItem = item
        }
    }
   
}
