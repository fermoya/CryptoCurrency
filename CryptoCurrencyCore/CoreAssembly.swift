//
//  CoreAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/13/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

public enum Tab: Int {
	case virtualCoin = 0
	case stock
	case currencyConverter
}

final public class CoreAssembly {
	
	private(set) lazy var webServiceAssembly = WebServiceAssembly()
	private(set) lazy var cryptoCurrenciesAssembly = CryptoCurrenciesAssembly(webServiceAssembly: webServiceAssembly, searchAssembly: searchAssembly, virtualGoodsAssembly: virtualGoodsAssembly)
	private(set) lazy var stocksAssembly = StocksAssembly(searchAssembly: searchAssembly, webServiceAssembly: webServiceAssembly, detailAssembly: detailAssembly)
	private(set) lazy var currencyConverterAssembly = CurrencyConverterAssembly(webServiceAssembly: webServiceAssembly)
	
	private(set) lazy var virtualGoodsAssembly = VirtualGoodsAssembly(webServiceAssembly: webServiceAssembly, detailAssembly: detailAssembly)
	private(set) lazy var searchAssembly = SearchAssembly(webServiceAssembly: webServiceAssembly, virtualGoodsViewControllerProvider: virtualGoodsAssembly.viewControllerProvider)
	private(set) lazy var detailAssembly = DetailAssembly(navigationControllers: navigationControllers, webServiceAssembly: webServiceAssembly)

	private var navigationControllers: [UINavigationController]
	
	public init(navigationControllers: [UINavigationController]) {
		self.navigationControllers = navigationControllers
	}
	
	public var cryptoCurrenciesViewController: UIViewController {
		return cryptoCurrenciesAssembly.viewController
	}
	
	public var stocksViewController: UIViewController {
		return stocksAssembly.viewController
	}
	
	public var currencyConverterController: UIViewController {
		return currencyConverterAssembly.viewController
	}
	
}
