//
//  AppDelegate.swift
//  CryptoCurrency
//
//  Created by Fernando Moya de Rivas on 6/13/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import CryptoCurrencyCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	let appAssembly = AppAssembly()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let navigationControllers = appAssembly.navigationControllers
		let tabBarController = appAssembly.tabBarController
		
		let window = appAssembly.window
		let cryptoCurrenciesViewController = appAssembly.cryptoCurrenciesViewController
		let stockViewController = appAssembly.stocksViewController
		let currencyConverterViewController = appAssembly.currencyConverterViewController
		
		window.rootViewController = tabBarController
		tabBarController.viewControllers = [navigationControllers[0], navigationControllers[1], navigationControllers[2]]
		
		navigationControllers[Tab.virtualCoin.rawValue].pushViewController(cryptoCurrenciesViewController, animated: true)
		navigationControllers[Tab.stock.rawValue].pushViewController(stockViewController, animated: true)
		navigationControllers[Tab.currencyConverter.rawValue].pushViewController(currencyConverterViewController, animated: true)

		window.makeKeyAndVisible()
		print("AppDelegate didFinishLaunchingWithOptions returning")
		return true
	}

}

extension UITabBarController {
	open override func viewDidLoad() {
		super.viewDidLoad()
		print("tabBar viewDidload returning")
	}
}
