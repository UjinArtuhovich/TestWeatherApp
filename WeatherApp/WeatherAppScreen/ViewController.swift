//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/7/21.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    private var dailyWeather = [Datum]()
    private var hourlyWeather = [Currently]()
    private var coordinate: CLLocationCoordinate2D!
    private var weatherAppViewModel: WeatherAppViewModel!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = Colors.myBlue
        view.backgroundColor = Colors.myBlue
        table.delegate = self
        table.dataSource = self
        table.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        table.register(CurrentInfoWeatherTableViewCell.nib(), forCellReuseIdentifier: CurrentInfoWeatherTableViewCell.identifier)
        table.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        getWeather()
    }
    fileprivate func getWeather() {
        LocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else {return}
            // MARK: Checking Internet connection
            if InternetObserver.shared.isInternetAvailable() {
                self.coordinate = location
                // MARK: Save in CoreData
                CityName.shared.getCityName(location: location) { cityName in
                    DataBaseManager.shareInstance.saveContext(latitudeData: location.latitude, longitudeData: location.longitude, cityName: cityName)
                }
            } else {
                let productDataBase = DataBaseManager.shareInstance.fetchData()
                self.coordinate = CLLocationCoordinate2D(latitude: productDataBase.latitudeData.first!.data, longitude: productDataBase.longitudeData.first!.data)
                HeaderView.shared.cityName = productDataBase.cityName.first!.name
                self.presentCustomAlertController(withTitle: "Error", message: "No internet connection", style: .alert)
            }
            // MARK: Building view with user location
            self.weatherAppViewModel = WeatherAppBuilder.getViewModel(longitude: String(self.coordinate.longitude), latitude: String(self.coordinate.latitude))
            self.weatherAppViewModel.getData()
            self.weatherAppViewModel.dataViewUpdated = { [weak self] in
                guard let self = self else {return}
                self.dailyWeather = self.weatherAppViewModel.weatherAppViewData.daily.data
                self.hourlyWeather = self.weatherAppViewModel.weatherAppViewData.hourly.data
                self.table.isHidden = false
                self.table.tableHeaderView = HeaderView.shared.createHeaderView(view: self.view, weather: self.dailyWeather.first!)
                self.table.reloadData()
            }
        }
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dailyWeather.count == 0 {
            return 0
        }
        if section == 0 {
            return 1
        }
        return dailyWeather.count+9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as! HourlyWeatherTableViewCell
            cell.configure(weather: hourlyWeather)
            return cell
        }
        if indexPath.row < dailyWeather.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
            cell.data = dailyWeather[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentInfoWeatherTableViewCell.identifier, for: indexPath) as! CurrentInfoWeatherTableViewCell
        cell.count = dailyWeather.count
        cell.configure(index: indexPath.row, weather: dailyWeather.first!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        if indexPath.row < dailyWeather.count {
            return 50
        }
        return 70
    }
}

