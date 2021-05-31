//
//  DetailViewControllerTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 22/05/2021.
//

import XCTest
import CoreLocation
import MapKit

@testable import ToDoListSampleInTDD

class DetailViewControllerTests : XCTestCase {
    
    var sut:DetailViewController!
    override func setUp() {
        sut = DetailViewController()
    }
    
    func test_HasTitle_Label() {
         sut = DetailViewController()
        sut.loadViewIfNeeded()
        let titleLabelIsSubView = sut.titleLabel.isDescendant(of: sut.view) 
        
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasMap_View() {
         sut = DetailViewController()
        sut.loadViewIfNeeded()
        let mapView = sut.mapView.isDescendant(of: sut.view) 
        
        XCTAssertTrue(mapView)
    }
    
    func test_SettingItemInfo_SetsTextToLabel() {
         sut = DetailViewController()
        let coordinate = CLLocationCoordinate2DMake(37.3345, -122.0091)
        let location = Location(name: "Foo", coordinate: coordinate)
        
        let item = ToDoItem(title: "Bar",itemDescription: "Baz", timestamp: 1456150025, location: location)
        
        let itemManager = ItemManager()
        
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, coordinate.longitude, accuracy: 0.001)
        
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
         sut = DetailViewController()

        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
        
    }
    
    override func tearDown() {
        sut.itemInfo?.0.removeAll()
        super.tearDown()
    }
}
