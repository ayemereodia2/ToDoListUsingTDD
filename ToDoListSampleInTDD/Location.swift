//
//  Location.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import Foundation
import CoreLocation

struct Location: Equatable {
  let name: String
    var coordinate: CLLocationCoordinate2D?
    
    var plistDict:[String:Any] {
        var dict = [String:Any]()
        dict[nameKey] = name
        
        if let coordinate = coordinate {
            dict[latitudeKey] = coordinate.latitude
            dict[longitudeKey] = coordinate.longitude
        }
        return dict
        
    }
    
    init?(dict:[String:Any]){
        guard let name = dict[nameKey] as? String else {
            return nil
        }
        
        let coordinates:CLLocationCoordinate2D?
        
        if let latitude = dict[latitudeKey] as? Double, let longitude = dict[longitudeKey] as? Double {
            coordinates = CLLocationCoordinate2DMake(latitude,longitude)
        }else{
            coordinates = nil
        }
        self.name = name
        self.coordinate = coordinates
        
    }
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    
    
  init(name: String,
       coordinate: CLLocationCoordinate2D? = nil) {
    self.name = name
    self.coordinate = coordinate 
    
  }
    
}


 func == (lhs: Location, rhs: Location) -> Bool {
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude {
        return false
    }
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude {
        return false
    }
    return true
}
