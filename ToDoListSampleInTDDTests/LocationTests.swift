//
//  LocationTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 31/05/2021.
//

import XCTest
import CoreLocation

class LocationTests: XCTestCase {
    
    func test_Location_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 6.0))
        let dict = location.plistDict
        XCTAssertNotNil(dict)
        
        let recreatedLocation = Location(dict:dict)
        XCTAssertEqual(location, recreatedLocation)
        
    }
}
