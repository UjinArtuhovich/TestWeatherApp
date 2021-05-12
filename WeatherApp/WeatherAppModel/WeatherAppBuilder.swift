//
//  WheatherAppBuilder.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/7/21.
//

//MARK: Builder to init the models
import Foundation
enum Location {
    static let latitude = 53.902334
    static let longitude = 27.5618791
}

class WeatherAppBuilder {
    static func getViewModel(longitude: String, latitude:String) -> WeatherAppViewModel {
        let baseUrl = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(latitude),\(longitude)?exclude=[flags,minutely]"
        print(baseUrl)
        let urlDataModel = URLDataModel(urlString: baseUrl)
        let dataManager = DataManager(URLdataModel: urlDataModel)
        let viewModel = WeatherAppViewModel(dataManager: dataManager)
        return viewModel
    }
}
