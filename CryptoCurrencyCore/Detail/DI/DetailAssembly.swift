//
//  DetailAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/20/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

protocol DetailViewControllerProvider {
	func detailViewController(for type: VirtualGoodType) -> DetailViewController
}

final class DetailAssembly {
	
	fileprivate var webServiceAssembly: WebServiceAssembly
	private var navigationControllers: [UINavigationController]
	
	init(navigationControllers: [UINavigationController], webServiceAssembly: WebServiceAssembly) {
		self.webServiceAssembly = webServiceAssembly
		self.navigationControllers = navigationControllers
	}
	
	var detailVirtualCoinNavigator: DetailNavigator {
		return DetailNavigator(navigationController: navigationControllers[Tab.virtualCoin.rawValue], viewControllerProvider: self)
	}
	
	var detailStockNavigator: DetailNavigator {
		return DetailNavigator(navigationController: navigationControllers[Tab.stock.rawValue], viewControllerProvider: self)
	}
	
	var detailCurrencyConverterNavigator: DetailNavigator {
		fatalError("\"detailCurrencyConverterNavigator\" has not been implemented")
	}
	
	private var virtualCoinDetailViewModel: DetailViewModel {
		return VirtualCoinDetailViewModel(repository: webServiceAssembly.cryptoCurrenciesRepository, dateFormatter: webServiceAssembly.dateFormatter)
	}
	
	private var stockDetailViewModel: DetailViewModel {
		return StockDetailViewModel(repository: webServiceAssembly.stocksRepository, dateFormater: webServiceAssembly.stockDateFormatter)
	}
}

extension DetailAssembly: DetailViewControllerProvider {
	func detailViewController(for type: VirtualGoodType) -> DetailViewController {
		switch type {
		case .virtualCoin:
			return DetailViewController(viewModel: virtualCoinDetailViewModel)
		case .stock:
			return DetailViewController(viewModel: stockDetailViewModel)
		}
		
	}
	
}
