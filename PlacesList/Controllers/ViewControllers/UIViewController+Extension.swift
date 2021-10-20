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
		self.present(alertController, animated: true, completion: nil)
	}
	
	/// Present loading screen
	///  https://www.hackingwithswift.com/example-code/uikit/how-to-use-uiactivityindicatorview-to-show-a-spinner-when-work-is-happening
	func presentLoadingScreen(){
		let child = SpinnerViewController()

		addChild(child)
		child.view.frame = view.frame
		view.addSubview(child.view)
		child.didMove(toParent: self)

		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			child.willMove(toParent: nil)
			child.view.removeFromSuperview()
			child.removeFromParent()
		}
	}
	

}
