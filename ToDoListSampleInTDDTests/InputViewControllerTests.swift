//
//  InputViewControllerTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 24/05/2021.
//

import XCTest

@testable import ToDoListSampleInTDD

class InputViewControllerTests : XCTestCase {
    
    var sut:InputViewController!
    
    override func setUp() {
        sut = InputViewController()
        sut.loadViewIfNeeded()
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
    
    func test_HasCancelButtonTwo() {
        let textFieldIsSubView = sut.cancelButton.isDescendant(of:sut.view)
        
        XCTAssertTrue(textFieldIsSubView)
    }
    
    
}
