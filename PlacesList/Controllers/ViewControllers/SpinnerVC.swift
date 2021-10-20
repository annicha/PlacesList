//
//  SpinnerVC.swift
//  PlacesList
//
//  Created by Anne on 20/10/21.
//

import UIKit

class SpinnerViewController: UIViewController {
	var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

	override func loadView() {
		view = UIView()
		view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)

		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.startAnimating()
		view.addSubview(spinner)

		NSLayoutConstraint.activate ([
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
		])
	}
}
