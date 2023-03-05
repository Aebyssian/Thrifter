//
//  ViewController.swift
//  Thrifter
//
//  Created by Jacob Wilson on 3/3/23.

//gonna have to make a new one
import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {
    var coordinates: [String] = [""] //latitude, longitude
    var firstTime = true
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded...")
        theMap.delegate = self //this doesnt crash though so ig the iboutlet creates an instance
        locationManager = CLLocationManager() //gotta create instance of class first. else it crashes
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
            let url = Bundle.main.url(forResource: "Come Sail Away", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            
    }

    @IBOutlet weak var theMap: MKMapView!
    var locationManager: CLLocationManager!
    var cityNameGetter = LocationData()
}

//MARK: - Location

extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if firstTime {
           
            firstTime = false
            theMap.isHidden = false
            let myLocation: CLLocation = locations.last!
            let coordinates = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            let cityName = cityNameGetter.getCityName(myLocation.coordinate.latitude, myLocation.coordinate.longitude)

            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 5000, longitudinalMeters: 5000)
            theMap.setRegion(region, animated: true)
            theMap.showsUserLocation = true
            print("Setting the center of the map...")
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.region = theMap.region
            searchRequest.naturalLanguageQuery = "Thrift stores in \(cityName)"
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response = response else {
                    return
                }
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation(__coordinate: item.placemark.coordinate)
                    annotation.title = "Thrift store"
                    self.theMap.addAnnotation(annotation)
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
             didFailWithError error: Error) {  print("Error fetching location") }
}

//MARK: - Map View

extension ViewController: MKMapViewDelegate {
    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else{
            let pinIdent = "Pin";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);

            }
            return pinView;
        }
    }
}
