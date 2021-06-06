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
        mock.itemManager = ItemManager()
        
        sut = ItemListViewController(dataProvider: mock)
    }

    func test_TableViewIsNotNilAfterViewDid() {
        
         sut = ItemListViewController()
        sut.dataProvider = MockDataSource()
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
        sut.dataProvider = MockDataSource()
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
        sut.dataProvider = MockDataSource()
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
    
    func test_ItemVC_SharesSameItemManager_WithToDoInputVC(){
        sut = ItemListViewController()
        sut.dataProvider = MockDataSource()
        let window = UIWindow(frame: UIScreen.main.bounds)
          window.makeKeyAndVisible()
          window.rootViewController = sut
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
        guard let inputViewController = sut.presentedViewController as? ToDoInputViewController else {
            XCTFail()
            return
        }
        guard let itemManger = inputViewController.itemManager else {
            XCTFail()
            return
        }
        XCTAssertTrue(sut.itemManager === itemManger)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvided(){
        sut = ItemListViewController(dataProvider: ItemListDataSource())
        let window = UIWindow(frame: UIScreen.main.bounds)
          window.makeKeyAndVisible()
          window.rootViewController = sut
        
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_IfTableReload_IsCalled() {
        let mocktableView = MockTabelView()

        sut = ItemListViewController(dataProvider: ItemListDataSource())
        sut.tableView = mocktableView
        
        let window = UIWindow(frame: UIScreen.main.bounds)
          window.makeKeyAndVisible()
          window.rootViewController = sut
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
        guard let inputViewController = sut.presentedViewController as? ToDoInputViewController else {
            XCTFail()
            return
        }
                
        inputViewController.titleTextField.text = "title two"
        inputViewController.saveButton.sendActions(for: .touchUpInside)
        
        sut.endAppearanceTransition()
        
        XCTAssertTrue(mocktableView.isReloadTableCalled)
        
    }
    
    func test_ItemSelectedNotifi_PushesDetailsVC(){
        let mockNavVC = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavVC
        sut.loadViewIfNeeded()
        sut.itemManager.add(ToDoItem(title: "Foo"))
        sut.itemManager.add(ToDoItem(title: "Bar"))
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "ItemSelectedNotification"), object: self, userInfo: ["index":1])
        
        guard let detailsVC = mockNavVC.lastPushedViewController as? DetailViewController else {
            return XCTFail()
        }
        
        guard let detailItemManager = detailsVC.itemInfo?.0 else { return XCTFail() }
        
        guard let index = detailsVC.itemInfo?.1 else { return XCTFail() }
        
        detailsVC.loadViewIfNeeded()
       
        XCTAssertNotNil(detailsVC.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
        
    }

}

extension ItemListViewControllerTest {
    class MockNavigationController : UINavigationController {
        var lastPushedViewController:UIViewController?
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            lastPushedViewController = viewController
            super.pushViewController(viewController, animated: true)
        }
    }
}

class MockDataSource: NSObject, UITableViewDataSource,UITableViewDelegate,ItemManagerSettable {
    
    var itemManager: ItemManager?
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

class MockTabelView : UITableView {
    
    var isReloadTableCalled:Bool = false

    override func reloadData() {
        
        self.isReloadTableCalled = true
    }
}
