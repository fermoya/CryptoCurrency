//
//  AppAssembly.swift
//  CryptoCurrency
//
//  Created by Fernando Moya de Rivas on 6/13/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import CryptoCurrencyCore

final class AppAssembly {
	
	private(set) lazy var window = UIWindow(frame: UIScreen.main.bounds)
	private(set) lazy var navigationControllers = [UINavigationController(), UINavigationController(), UINavigationController()]
	private(set) lazy var tabBarController =  UITabBarController()
	private(set) lazy var coreAssembly = CoreAssembly(navigationControllers: navigationControllers)
	
	var cryptoCurrenciesViewController: UIViewController {
		return coreAssembly.cryptoCurrenciesViewController
	}
	
	var stocksViewController: UIViewController {
		return coreAssembly.stocksViewController
	}
	
	var currencyConverterViewController: UIViewController {
		return coreAssembly.currencyConverterController
	}

}
