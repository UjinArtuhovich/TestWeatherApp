//
//  DataBaseManager.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/12/21.
//

import Foundation
import UIKit
import CoreData
class DataBaseManager {
    static let shareInstance = DataBaseManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func saveContext(latitudeData: Double, longitudeData: Double, cityName: String) {
        let latitude = Latitude(context: context)
        let longitude = Longitude(context: context)
        let city = City(context: context)
        latitude.data = latitudeData
        longitude.data = longitudeData
        city.name = cityName
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    func fetchData() -> (latitudeData: [Latitude], longitudeData: [Longitude], cityName: [City]) {
        var fetchingTuple = (latitudeData: [Latitude](), longitudeData: [Longitude](), cityName: [City]())
        let fetchLatitudeData = NSFetchRequest<NSFetchRequestResult>(entityName: "Latitude")
        let fetchLongitudeData = NSFetchRequest<NSFetchRequestResult>(entityName: "Longitude")
        let fetchCityName = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        do {
            fetchingTuple.latitudeData = try context.fetch(fetchLatitudeData) as! [Latitude]
            fetchingTuple.longitudeData = try context.fetch(fetchLongitudeData) as! [Longitude]
            fetchingTuple.cityName = try context.fetch(fetchCityName) as! [City]
        } catch let error as NSError {
            print(error)
        }
        return fetchingTuple
    }
}
