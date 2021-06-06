//
//  ItemCellTest.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 22/05/2021.
//

import XCTest
@testable import ToDoListSampleInTDD

class ItemCellTest: XCTestCase {
    var fakeDataSource:FakeDataSource!
    var viewController:ItemListViewController!
    var cell:ItemCell!
    
    override func setUp() {
        fakeDataSource = FakeDataSource()
        viewController = ItemListViewController()
        viewController.dataProvider = MockDataSource()
        viewController.tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        viewController.loadViewIfNeeded()
        viewController.tableView.dataSource = fakeDataSource
        cell = viewController.tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row:0, section: 0)) as? ItemCell
        cell.configCell(with: ToDoItem(title: "Foo"))
    }
    
    func test_HasNameLabel() {
        
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func test_HasLocationLabel() {
        
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func test_HasDateLabel() {
        
        XCTAssertTrue(cell.dateLabel.isDescendant(of:cell.contentView))
    }
    
    func test_ConfigCell_SetsTitle() {
        
        cell.configCell(with: ToDoItem(title: "Foo"))
        XCTAssertEqual(cell.titleLabel.text, "Foo")
    }
    
    func xtest_ConfigCell_SetsDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timeStamp = dateFormatter.date(from: "02/17/1989")?.timeIntervalSince1970
        cell.configCell(with: ToDoItem(title: "Foo", timestamp: timeStamp))
        XCTAssertEqual(cell.dateLabel.text, "02/17/1989")
    }
    
    func test_ConfigCell_SetsLocationName() {
        let location = Location(name: "Lagos")
        cell.configCell(with: ToDoItem(title: "Boo", location: location))
        
        XCTAssertEqual(cell.locationLabel.text, location.name)
    }
    
    func test_Title_WhenItemIsChecked_IsStrokeThrough() {
        let location = Location(name: "Lagos")
        let item = ToDoItem(title: "Boo", location: location)
        cell.configCell(with: item, checked: true)
        
        let attributedString = NSAttributedString(string: "Lagos", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
    
}


extension ItemCellTest {
    class FakeDataSource : NSObject, UITableViewDataSource {
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
