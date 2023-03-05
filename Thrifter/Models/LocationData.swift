//
//  LocationData.swift
//  Thrifter
//
//  Created by Jacob Wilson on 3/2/23.
//

import Foundation
import CoreLocation

struct LocationData {
    let locationURL = "https://maps.googleapis.com/maps/api/geocode/json?sensor=true&key=AIzaSyAqiNjD5uNYKE7MCh8TjYWtpCsRhc-kjpU&latlng="
    
  
    mutating func getCityName(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) -> String {
        let url = URL(string: "\(locationURL)\(lat),\(lon)")!
        var cityName: String?
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let decoder = JSONDecoder()
                
            let locationData = try! decoder.decode(GoogleMapsInfo.self, from: data!)
            cityName = locationData.results[0].address_components[2].long_name
        }
        
        task.resume()
        
        while cityName == nil {}
        return cityName ?? "Biloxi"
    }
}
