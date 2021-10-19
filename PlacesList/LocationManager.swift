//
//  LocationManager.swift
//  PlacesList
//
//  Created by Anne on 19/10/21.
//

import CoreLocation

enum PlacesLocationError: String, Error {
	case deniedPermission 	= "Location permission was denied. Please go to your setting to change permission."
	case notSupported		= "This device does not support significant location change monitoring."
	case unknown			= "Sorry, an unknown error occured while checking location. Please try again later or contact support."
	case locationUnknown	= "Sorry, we couldn't determine your current location. Please try again later."
	case network			= "Sorry, the device's network is not avialable. Please check your connection or try again later."
}

class LocationManager: NSObject, CLLocationManagerDelegate {
		
	static let shared = LocationManager()
	private override init() {}
	
	var locationManager = CLLocationManager()
	var locationUpdateHandler: ((Result<CLLocation, PlacesLocationError>) -> Void)?

	func startMonitoringSignificantLocationChanges(_ completion: @escaping (Result<CLLocation, PlacesLocationError>) -> Void) {
		if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
			completion(.failure(PlacesLocationError.notSupported)); return
		}
		
		locationManager.requestWhenInUseAuthorization()
		
		guard locationManager.authorizationStatus != .denied else {
			completion(.failure(PlacesLocationError.deniedPermission)); return
		}

		locationManager.delegate = self
		locationManager.startMonitoringSignificantLocationChanges()
		locationUpdateHandler = completion // pass on the closure we received and store it in our handler to be used later in didUpdaetLocations
	}
	
	func stopMonitoringSignificantLocationChanges(){
		locationManager.stopMonitoringSignificantLocationChanges()
	}
	
	// MARK: - Delegate Methods
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let newLocation = locations.last else { return }
		locationUpdateHandler?(.success(newLocation))
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		if let error = error as? CLError {
			manager.stopMonitoringSignificantLocationChanges()
			
			switch error.code {
			case .locationUnknown:
				locationUpdateHandler?(.failure(PlacesLocationError.locationUnknown))
			case .network:
				locationUpdateHandler?(.failure(PlacesLocationError.network))
			default:
				// other CLError occured but not handled
				print("\n🍰 Error = \(error.localizedDescription)")
				locationUpdateHandler?(.failure(PlacesLocationError.unknown))
			}
			return
		}
		
		print("\n🙇🏻‍♀️ Error = \(error.localizedDescription)")
		locationUpdateHandler?(.failure(PlacesLocationError.unknown))
	}
}
