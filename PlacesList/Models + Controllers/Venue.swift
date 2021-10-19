//
//  Venue.swift
//  PlacesList
//
//  Created by Anne on 19/10/21.
//

struct Venue: Decodable {
	let id: String
	let name: String
	let address: String?
	let postalCode: String?
	let city: String?
	let state: String?
	let country: String?
	let iconPath: String?
	let iconSuffix: String?

	private enum CodingKeys: String, CodingKey {
		case id, name, address, postalCode, city, state, country
		case iconPath = "prefix"
		case iconSuffix = "suffix"
	}
}


extension Venue {
	init?(_ item: [String: Any]) {
		guard let venue = item["venue"] as? [String: Any],
			  let id	= venue[CodingKeys.id.rawValue] as? String,
			  let name 	= venue[CodingKeys.name.rawValue] as? String else { return nil }
		
		// Location level
		guard let location 	= venue["location"] as? [String:Any] else { return nil }
		
		let city		= location[CodingKeys.city.rawValue] as? String
		let address 	= location[CodingKeys.address.rawValue] as? String
		let postalCode 	= location[CodingKeys.postalCode.rawValue] as? String
		let state 		= location[CodingKeys.state.rawValue] as? String
		let country 	= location[CodingKeys.country.rawValue] as? String
		
		// Category level
		var iconPath: String?
		var iconSuffix: String?
		
		if let categories 	= venue["categories"] as? [[String:Any]] {
			let primaryCategory: [String:Any]? = categories.first(where: {
				if let primaryStatus = $0["primary"] as? Bool {
					return primaryStatus == true
				}
				return false
			})
			
			// Icon level
			let iconDict = primaryCategory?["icon"] as? [String:Any]
			iconPath 	= iconDict?[CodingKeys.iconPath.rawValue] as? String
			iconSuffix	= iconDict?[CodingKeys.iconSuffix.rawValue] as? String
		}
						
		// Initialize properties
		self.id 		= id
		self.name 		= name
		self.address 	= address
		self.postalCode = postalCode
		self.city		= city
		self.state		= state
		self.country	= country
		self.iconPath	= iconPath
		self.iconSuffix = iconSuffix
	}
}


