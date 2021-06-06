//
//  InitialUITest.swift
//  ToDoListSampleInTDDUITests
//
//  Created by Ayemere  Odia  on 03/06/2021.
//

import XCTest
@testable import ToDoListSampleInTDD

class InitialUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

            func testExample()  {
                let app = XCUIApplication()
                app.navigationBars["ToDoListSampleInTDD.ItemListView"].buttons["Add"].tap()
                let titleTextField = app.textFields["title"]
                titleTextField.tap()
                titleTextField.typeText("Meeting")
                let dateTextField = app.textFields["date"]
                dateTextField.tap()
                dateTextField.typeText("02/22/2018")
                let addressTextField = app.textFields["address"]
                addressTextField.tap()
                addressTextField.typeText("Infinite Loop 1, Cupertino")
                app.buttons["Save"].tap()
                
                XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
                XCTAssertTrue(app.tables.staticTexts["02/22/2018"].exists)
                XCTAssertTrue(app.tables.staticTexts["Infinite Loop 1, Cupertino"].exists)


    }

}
