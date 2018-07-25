//
//  DetailNavigator.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/20/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift

class DetailNavigator {
	
	private var navigationController: UINavigationController
	private var viewControllerProvider: DetailViewControllerProvider
	
	init(navigationController: UINavigationController, viewControllerProvider: DetailViewControllerProvider) {
		self.navigationController = navigationController
		self.viewControllerProvider = viewControllerProvider
	}
	
	func navigate(type: VirtualGoodType, binding: @escaping (DetailViewModel) -> Void) -> Completable {
		return Completable.create { [unowned self] completable in
			let detailViewController = self.viewControllerProvider.detailViewController(for: type)
			self.navigationController.pushViewController(detailViewController, animated: true)
			
			binding(detailViewController.viewModel)
			completable(.completed)
			
			return Disposables.create()
		}
		
	}
	
}
