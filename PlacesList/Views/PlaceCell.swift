//
//  PlaceCell.swift
//  PlacesList
//
//  Created by Anne on 20/10/21.
//

import UIKit


class PlaceCell: UITableViewCell {
	
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var addresLabel: UILabel!
	@IBOutlet weak var iconImageBackgroundView: UIView!
	
	private var venue: Venue?
	private var image: UIImage? {
		didSet { setVenueProperties() }
	}
	

    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .secondarySystemBackground
		iconImageBackgroundView.backgroundColor = UIColor.placeIconColor
		
		hideElements(true)
    }
	
	// MARK: - Methods
	
	/// Store data into this cell and trigger updating properties
	func setData(venue: Venue, image: UIImage? = nil){
		self.venue = venue
		self.image = image
	}
	
	private func setVenueProperties(){
		guard let venue = venue else { return }
		placeNameLabel.text	 = "\(venue.name)"
		addresLabel.text = getAddress()
		
		if let image = image {
			iconImageView.image = image
		}
		iconImageBackgroundView.layer.cornerRadius = iconImageBackgroundView.frame.width / 2
		hideElements(false)
		self.setNeedsLayout()

	}
	
	private func hideElements(_ hiddenStatus: Bool) {
		iconImageBackgroundView.isHidden = hiddenStatus
		iconImageView.isHidden = hiddenStatus
		placeNameLabel.isHidden = hiddenStatus
		addresLabel.isHidden = hiddenStatus
	}
	
	private func getAddress() -> String {
		guard let venue = venue else { fatalError("Expected venue.") }
		var formattedAddress = ""
		
		// section 1
		if let address = venue.address {
			formattedAddress += "\(address) \n"
		}
		
		// section 2
		let city = venue.city
		let state = venue.state
		if city != nil || state != nil {
			if let city = city {
				formattedAddress += "\(city) "
			}
			
			if let state = state {
				formattedAddress += "\(state)\n"
			}
		}
		
		// section 3
		let country = venue.country
		let postalCode = venue.postalCode
		
		if country != nil || postalCode != nil {
			if let country = country {
				formattedAddress += "\(country) "
			}
			
			if let postalCode = postalCode {
				formattedAddress += "\(postalCode)"
			}
		}
		
		return formattedAddress
	}

}
