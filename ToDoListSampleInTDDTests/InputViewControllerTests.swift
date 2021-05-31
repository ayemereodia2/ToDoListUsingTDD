//
//  InputViewControllerTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 24/05/2021.
//

import XCTest
import CoreLocation

@testable import ToDoListSampleInTDD

class InputViewControllerTests : XCTestCase {
    
    var sut:ToDoInputViewController!
    var placeMark:MockPlaceMark!
    
    override func setUp() {
        sut = ToDoInputViewController()
        sut.loadViewIfNeeded()
        placeMark = MockPlaceMark()
    }
    
    func test_HasTitleTextfield() {
        let textFieldIsSubView = sut.titleTextField.isDescendant(of:sut.view)
        
        
        XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasSaveButton() {
        let textFieldIsSubView = sut.saveButton.isDescendant(of:sut.view)
        
        XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasCancelButton() {
        let textFieldIsSubView = sut.cancelButton.isDescendant(of:sut.view)
        
        XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasAddressTextField() {
        let textFieldIsSubView = sut.addressTexfield.isDescendant(of:sut.view)
        XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasDateTextField() {
        let textFieldIsSubView = sut.dateTextField.isDescendant(of:sut.view)
        XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_Save_Uses_GeoCoderToGetCoordinateFromAddress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let timestamp = 1456095600.0
        let date = Date(timeIntervalSince1970: timestamp)
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.titleTextField.text = "Foo"
        sut.addressTexfield.text = "Infinite Loop 1, Cupertino"
        let mockGeoCoder = MockGeoCoder()
        sut.geoCoder = mockGeoCoder
        sut.itemManager = ItemManager()
        
        sut.save()
        
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placeMark.mockCoordinate = coordinate
        mockGeoCoder.completionHandler?([placeMark], nil)
        let item = sut.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Foo", itemDescription: "description", timestamp: timestamp, location: Location(name: "Infinite Loop 1, Cupertino", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
        
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton:UIButton = sut.saveButton

        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(saveButton, "Button is not nil")
        
        guard let action1 = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(action1.contains("saveButtonTappedWithSender:"))
    }
    
    func test_GeoCoder_Fetches_Coordinates(){
        let geoCoderAnswered = expectation(description:"Geocoder")
        
        let address = "Infinite Loop 1, Cupertino"
        CLGeocoder().geocodeAddressString(address){
            (placeMarks, error) -> Void in 
            let coordinate = placeMarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(longitude, -122.0300, accuracy:0.001)
            
            XCTAssertEqual(latitude, 37.3316, accuracy:0.001)
            
            geoCoderAnswered.fulfill()
            
        }
        
        waitForExpectations(timeout:3, handler:nil)
 
    }
    
    func test_Save_DismissGot_Called(){
        let mockVC = MockToDoInputVC()
        mockVC.titleTextField = UITextField()
        mockVC.addressTexfield = UITextField()
        mockVC.dateTextField = UITextField()
        mockVC.titleTextField.text = "title added"
        mockVC.save()
        
        XCTAssertTrue(mockVC.dismissGotCalled)
    }
    
    override func tearDown() {
        sut.itemManager?.removeAll()
        super.tearDown()
    }
}

extension InputViewControllerTests {
    
   public class MockGeoCoder : CLGeocoder {
        var completionHandler:CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlaceMark : CLPlacemark {
        var mockCoordinate : CLLocationCoordinate2D?
        override var location : CLLocation? {
            guard let coordinate = mockCoordinate else {
                return CLLocation()
            }
            
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    class MockToDoInputVC : ToDoInputViewController {
        var dismissGotCalled:Bool = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
        }
        
    }
    
}
