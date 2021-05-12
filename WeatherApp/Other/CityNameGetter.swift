//
//  CityNameGetter.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/12/21.
//

import Foundation
import CoreLocation
class CityName {
    private var cityName: String!
    static let shared = CityName()
    
    func getCityName(location: CLLocationCoordinate2D, completion: @escaping(String)->()){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemark, error in
            guard let placemark = placemark else {return}
            self.cityName = placemark.first!.locality
            completion(self.cityName)
        }
    }
}
