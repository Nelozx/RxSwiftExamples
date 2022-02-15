//
//  GeolocationService.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/15.
//

import RxCocoa
import CoreLocation
import RxSwift


class GeolocationService {
    
    static let instance = GeolocationService()
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    private let locationManager = CLLocationManager()
    
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
        authorized = Observable.deferred { [weak locationManager] in
                let status = CLLocationManager.authorizationStatus()
                guard let locationManager = locationManager else {
                    return Observable.just(status)
                }
                return locationManager
                    .rx.didChangeAuthorizationStatus
                    .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map {
            switch $0 {
            case .authorizedAlways,
                 .authorizedWhenInUse: return true
            default: return false
            }
        }
        
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap { $0.last.map(Driver.just) ?? Driver.empty() }
            .map { $0.coordinate }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}
