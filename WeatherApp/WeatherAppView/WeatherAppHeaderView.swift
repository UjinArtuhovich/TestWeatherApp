//
//  WeatherAppHeaderView.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/9/21.
//

import Foundation
import UIKit
import CoreLocation
class HeaderView {
    static let shared = HeaderView()
    var cityName: String!
    func createHeaderView(view: UIView, weather: Datum) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width-120))
        
        headerView.backgroundColor = Colors.myBlue
        
        //MARK: locationLabel
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/7))
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 35)
        
        //MARK: summaryLabel
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        summaryLabel.textColor = .white
        summaryLabel.font = UIFont.systemFont(ofSize: 15)
        
        //MARK: temperatureLabel
        let temperatureLabel = UILabel(frame: CGRect(x: 10, y: summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont.systemFont(ofSize: 60)
        
        //MARK: temperaturesLabel
        let temperaturesLabel = UILabel(frame: CGRect(x: 10, y: temperatureLabel.frame.size.height-20, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        temperaturesLabel.textColor = .white
        temperaturesLabel.font = UIFont.systemFont(ofSize: 15)
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(temperaturesLabel)
        headerView.addSubview(summaryLabel)
        
        temperaturesLabel.textAlignment = .center
        temperatureLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
// MARK: Checking Internet connection
        if InternetObserver.shared.isInternetAvailable() {
            LocationManager.shared.getUserLocation { location in
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemark, error in
                    guard let placemark = placemark else {return}
                    locationLabel.text = placemark.first!.locality
                }
            }
        } else {
            
            locationLabel.text = cityName
        }
        temperatureLabel.text = "\(Int(weather.temperatureMax - weather.temperatureLow))°"
        temperaturesLabel.text = "H:\(Int(weather.temperatureMax))° L:\(Int(weather.temperatureLow))°"
        summaryLabel.text = weather.summary
        
        return headerView
    }
}
