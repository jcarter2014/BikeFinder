//
//  ViewController.swift
//  BikeFinder
//
//  Created by John Carter on 1/9/18.
//  Copyright © 2018 Jack Carter. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var stationQuantity: [String: Any] = [:]
    var stationDocks: [String: Any] = [:]
    var stationDistances: [String: Double] = [:]
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        map.showsUserLocation = true
        
    }
    
    
    @IBAction func getCapitalBikeLocations() {
        
        Alamofire.request("https://gbfs.capitalbikeshare.com/gbfs/en/station_information.json").responseJSON { (response) in
            
            if let JSON = response.result.value as? [String: Any] {
                
                if let data = JSON["data"] as? [String: Any] {
                    
                    if let stations = data["stations"] as? [[String: Any]] {
                        
                        for eachItem in stations {

                            let annotation = MKPointAnnotation()
                            annotation.coordinate.latitude = eachItem["lat"] as! CLLocationDegrees
                            annotation.coordinate.longitude = eachItem["lon"] as! CLLocationDegrees
                            
                            let stationID = eachItem["station_id"] as! String
                            //print(stationID)
                            let numBikes = self.stationQuantity[stationID]!
                            let numDocks = self.stationDocks[stationID]!
                            let numBikesToString = String(describing: numBikes)
                            let numDocksToString = String(describing: numDocks)
                            
                            annotation.title = "\(numBikesToString) bikes"
                            annotation.subtitle = "\(numDocksToString) docks"
                            let mySpot = self.manager.location
                            let annotationSpot = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                            let distance = mySpot?.distance(from: annotationSpot)
                            
                            let stationName = eachItem["name"] as! String
                            self.stationDistances[stationName] = distance!
                            
                            self.map.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
    func getCapitalBikeQuantities() {
        
        Alamofire.request("https://gbfs.capitalbikeshare.com/gbfs/en/station_status.json").responseJSON { (response) in
            if let JSON = response.result.value as? [String: Any] {
                
                if let data = JSON["data"] as? [String: Any] {
                    
                    if let stations = data["stations"] as? [[String: Any]] {
                        for eachItem in stations {
                            
                            let stationID = eachItem["station_id"] as! String

                            let numBikes = eachItem["num_bikes_available"]
                            let numDocks = eachItem["num_docks_available"]
                            
                            self.stationQuantity[stationID] = numBikes
                            self.stationDocks[stationID] = numDocks
                            
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.922, -77.076)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true

        getCapitalBikeLocations()
        getCapitalBikeQuantities()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func printStationDocks(_ sender: Any) {
        print(stationDocks)
    }
    
    @IBAction func printStationQuantities(_ sender: Any) {
        print(stationQuantity)
    }
    
    @IBAction func printStationDistances(_ sender: Any) {
        print(stationDistances)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

