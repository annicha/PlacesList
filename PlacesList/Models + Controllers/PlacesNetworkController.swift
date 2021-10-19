//
//  PlacesNetworkController.swift
//  PlacesList
//
//  Created by Anne on 19/10/21.
//

import CoreLocation

struct FoursquareConstantsKeys {
	static let baseURL				= "https://api.foursquare.com/v2"
	static let version				= "20211019"
	
	// Query key names
	static let clientIDKeyName		= "client_id"
	static let clientSecretKeyName	= "client_secret"
	static let locationKeyName		= "ll"
	static let versionKeyName		= "v"
	static let limitKeyName			= "limit"
	static let offsetKeyName		= "offset"
}

/// Error message for foursquare network fetching. Use .rawValue to get error message.
enum PLNetworkError: String, Error {
	case invalidURL 		= "Invalid URL. Please contact support."
	case invalidResponse 	= "Invalid response from the server. Please try again."
	case invalidData 		= "The data received from the server was invalid. Please try again."
	case unableToComplete 	= "Unable to complete your request. Please check your internet connection."
	case endOfResults		= "There's no more data to show."
}

class PlacesNetworkController {
	private var limit			= 10
	private var currentOffset 	= 0
	private var maxOffset: Int?
	
	static let shared = PlacesNetworkController()
	let baseURL = URL(string: FoursquareConstantsKeys.baseURL)
	
	private init() {}
	
	// MARK: - Methods
	private func parseJSON(_ data: Data, completion:@escaping (Result<[Venue], PLNetworkError>) -> Void) {
		do {
			let jsonData = try JSONSerialization.jsonObject(with: data, options: [])

			guard let jsonObject 	= jsonData as? [String: Any],
				  let response		= jsonObject["response"] as? [String: Any],
				  let totalResults 	= response["totalResults"] as? Int,
				  let groups		= response["groups"] as? [[String: Any]],
				  let items			= groups[0]["items"] as? [[String: Any]] else {
					   print("\n❌ Couldn't get top level result ")
					   completion(.failure(.invalidData)); return
			}
			
			self.maxOffset 		= totalResults / self.limit
			self.currentOffset += 1
			
			var venues: [Venue] = []
			for item in items {
				if let venue = Venue(item) {
					venues += [venue]
				} else {
					print("\n🥞 Couldn't parse a vanue from item!")
				}
			}
			completion(.success(venues)); return

		} catch {
			print("Couldn't decode data!! 😡")
			completion(.failure(.invalidData)); return
		}
	}
	
	func fetchRecommendations(location: CLLocation, completion:@escaping (Result<[Venue], PLNetworkError>) -> Void){
		var maxOffsetReached: Bool = false
		if let maxOffset = maxOffset {
			maxOffsetReached = maxOffset >= currentOffset
		}
		
		guard !maxOffsetReached else { completion(.failure(.endOfResults)); return }
		
		/* Try with mock json, comment out lines below this to test mock data */
		// fetchMockJsonData(completion: completion); return
		
		let exploreURL = baseURL?.appendingPathComponent("venues")
			.appendingPathComponent("explore")

		guard let url = exploreURL else {
			completion(.failure(.invalidURL)); return
		}

		let coordinate = location.coordinate
		let locationString = "\(coordinate.latitude),\(coordinate.longitude)"

		var components = URLComponents.init(url: url, resolvingAgainstBaseURL: true)

		let clientIDQuery = URLQueryItem(name: FoursquareConstantsKeys.clientIDKeyName,
										 value: SecretKeys.clientID)
		let clientSecretQuery = URLQueryItem(name: FoursquareConstantsKeys.clientSecretKeyName,
											 value: SecretKeys.clientSecret)

		let versionQuery = URLQueryItem(name: FoursquareConstantsKeys.versionKeyName,
										value: FoursquareConstantsKeys.version)

		let locationQuery = URLQueryItem(name: FoursquareConstantsKeys.locationKeyName,
										 value: locationString)

		let limitQuery = URLQueryItem(name: FoursquareConstantsKeys.limitKeyName,
									  value: String(limit))

		let offsetQuery = URLQueryItem(name: FoursquareConstantsKeys.offsetKeyName,
									   value: String(currentOffset))
		components?.queryItems = [clientIDQuery, clientSecretQuery, versionQuery, locationQuery, limitQuery, offsetQuery]

		// Prepare for dataTask
		guard let endPointURL = components?.url else {
			completion(.failure(.invalidURL)); return
		}

		URLSession.shared.dataTask(with: endPointURL) { (data, response, error) in
			if let error = error {
				print("\(error.localizedDescription) \(error) in function \(#function)")
				completion(.failure(.unableToComplete))
				return
			}

			guard let response = response as? HTTPURLResponse,
				  response.statusCode == 200 else {
					  completion(.failure(.invalidResponse))
					  return
			}

			guard let data = data else {
				completion(.failure(.invalidData)); return
			}

			self.parseJSON(data, completion: completion)
			
		}.resume()
	}
	
	private func fetchMockJsonData(completion:@escaping (Result<[Venue], PLNetworkError>) -> Void){
		guard let exampleFilePath = Bundle.main.path(forResource: "ExampleResponse", ofType: "json") else {
			print("\n🧪 Invalid file path")
			completion(.failure(.invalidURL)); return
		}
		
		guard let data = FileManager.default.contents(atPath: exampleFilePath) else {
			completion(.failure(.invalidData)); return
		}
		
		parseJSON(data, completion: completion); return
	}
	

}
