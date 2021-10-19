//
//  PlacesListTBVC.swift
//  PlacesList
//
//  Created by Anne on 18/10/21.
//

import UIKit
import CoreLocation

class PlacesListTBVC: UITableViewController {
	
	var venues = PlacesNetworkController.shared.venues

    override func viewDidLoad() {
        super.viewDidLoad()
		LocationManager.shared.startMonitoringSignificantLocationChanges { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let location):
				self.getVenuesFrom(location)
			case .failure(let error):
				DispatchQueue.main.async {
					self.presentSimpleAlert(title: "Error", message: error.rawValue)
				}
			}
		}
    }
	
	// MARK: - Methods
	func getVenuesFrom(_ location: CLLocation){
		PlacesNetworkController.shared.fetchRecommendations(location: location) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let venues):
				self.venues = venues
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(let error):
				guard error != .endOfResults else { return }
				DispatchQueue.main.async {
					self.presentSimpleAlert(title: "Error", message: error.rawValue)
				}
			}
		}
	}
	
	
	func getIconImage(fromPath path: String, suffix: String, completion: @escaping(UIImage?) -> Void){
		PlacesNetworkController.shared.fetchIconImage(fromPath: path, suffix: suffix) { result in
			switch result {
			case .success(let image): completion(image)
			case .failure(_): completion(nil)
			}
		}
	}
	
    // MARK: - Table view methods
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }

		let venue = venues[indexPath.row]

		guard let path = venue.iconPath,
			  let suffix = venue.iconSuffix else {
			cell.setData(venue: venue)
			return cell
		}
		
		getIconImage(fromPath: path, suffix: suffix) { image in
			DispatchQueue.main.async {
				cell.setData(venue: venue, image: image)
			}
		}

        return cell
    }
	
	

}
