//
//  LocationManager.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//

import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private (set) var didChangeLocationAuthorization: CurrentValueSubject<CLAuthorizationStatus, Never> = .init(.notDetermined)
    
    private let manager = CLLocationManager()
    private let notificationCenter = NotificationCenter.default
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private override init() { }
    
    func checkLocationService() {
        setupLocationManager()
        checkLocationManagerAuthorization()
    }
    
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    private func checkLocationManagerAuthorization() {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus{
            case .notDetermined:
                print("::: -> Location: notDetermined")
                manager.requestWhenInUseAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("::: -> Location: authorizedWhenInUse")
                manager.startUpdatingLocation()
                
            case .denied, .restricted:
                print("::: -> Location: denied")
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationManagerAuthorization()
        didChangeLocationAuthorization.send(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
