//
//  LocationManager.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var completionHandler:((Location?) -> Void)?

    //MARK: Location receiving

    func getUserLocation(completionHandler: @escaping (Location?) -> Void) {

        self.completionHandler = completionHandler
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            completionHandler(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if locValue.latitude != 0.0 && locValue.longitude != 0.0 {
            locationManager.stopUpdatingLocation()
            completionHandler!(Location(lat: locValue.latitude, lon: locValue.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            completionHandler!(nil)
        }
    }
    
}
