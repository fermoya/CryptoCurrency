//
//  VirtualGoodsListNavigator.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class VirtualGoodsNavigator {
	
	private var viewControllerProvider: VirtualGoodsViewControllerProvider
	
	init(viewControllerProvider: VirtualGoodsViewControllerProvider) {
		self.viewControllerProvider = viewControllerProvider
	}
	
	func install(over parentViewController: UIViewController, in containerView: UIView, type: VirtualGoodType, binding: (VirtualGoodsViewModel) -> Void) {
		let viewController = viewControllerProvider.virtualGoodsViewController(for: type)
		viewController.willMove(toParentViewController: parentViewController)
		parentViewController.addChildViewController(viewController)
		containerView.addSubview(viewController.view)
		viewController.didMove(toParentViewController: parentViewController)
		
		viewController.view.translatesAutoresizingMaskIntoConstraints = false
		let top = NSLayoutConstraint(item: viewController.view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
		let bottom = NSLayoutConstraint(item: viewController.view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
		let leading = NSLayoutConstraint(item: viewController.view, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
		let trailing = NSLayoutConstraint(item: viewController.view, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
		
		containerView.addConstraints([top, bottom, leading, trailing])
		binding(viewController.viewModel)
	}
	
}
