//
//  Extensions.swift
//  PlacesList
//
//  Created by Anne on 19/10/21.
//

import UIKit

extension UIViewController {
	/// Present an alert that has no handler
	func presentSimpleAlert(title: String, message: String){
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
}
