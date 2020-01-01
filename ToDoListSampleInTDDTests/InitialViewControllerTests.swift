//
//  InitialViewControllerTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 29/05/2021.
//

import XCTest

class InitialViewController: XCTestCase {
    
    
    func test_InitialVC_IsItemListViewController(){
        let dataProver = ItemListDataSource()
        let rootViewController = UINavigationController(rootViewController: ItemListViewController(dataProvider: dataProver))
        
        let firstVC = rootViewController.viewControllers[0]
        XCTAssertTrue(firstVC is ItemListViewController)
    }
    
    
}
