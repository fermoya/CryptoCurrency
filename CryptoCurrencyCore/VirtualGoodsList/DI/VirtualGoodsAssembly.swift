//
//  VirtualGoodsAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

protocol VirtualGoodsViewControllerProvider {
	func virtualGoodsViewController(for type: VirtualGoodType) -> VirtualGoodsViewController
	func virtualGoodsViewController(for type: VirtualGoodSearchType) -> VirtualGoodsSearchViewController
}

final class VirtualGoodsAssembly {
	
	private var webServiceAssembly: WebServiceAssembly
	private var detailAssembly: DetailAssembly
	
	init(webServiceAssembly: WebServiceAssembly, detailAssembly: DetailAssembly) {
		self.webServiceAssembly = webServiceAssembly
		self.detailAssembly = detailAssembly
	}

	var navigator: VirtualGoodsNavigator {
		return VirtualGoodsNavigator(viewControllerProvider: self)
	}
	
	var cryptoCurrenciesViewModel: CryptoCurrencyListViewModel {
		return CryptoCurrencyListViewModel(repository: webServiceAssembly.cryptoCurrenciesRepository, detailNavigator: detailAssembly.detailVirtualCoinNavigator)
	}
	
	var stocksViewModel: StockListViewModel {
		return StockListViewModel(repository: webServiceAssembly.stocksRepository, detailNavigator: detailAssembly.detailStockNavigator)
	}
	
	var cryptoCurrenciesSearchViewModel: CryptoCurrencySearchListViewModel {
		return CryptoCurrencySearchListViewModel()
	}
	
	var stockSearchViewModel: StockSearchListViewModel {
		return StockSearchListViewModel(repository: webServiceAssembly.stocksRepository, detailNavigator: detailAssembly.detailStockNavigator)
	}
	
	var viewControllerProvider: VirtualGoodsViewControllerProvider {
		return self
	}
}

extension VirtualGoodsAssembly: VirtualGoodsViewControllerProvider {
	func virtualGoodsViewController(for type: VirtualGoodSearchType) -> VirtualGoodsSearchViewController {
		switch type {
		case .virtualCoin:
			return VirtualGoodsSearchViewController(viewModel: cryptoCurrenciesSearchViewModel)
		case .stock:
			return VirtualGoodsSearchViewController(viewModel: stockSearchViewModel)
		}
	}
	
	func virtualGoodsViewController(for type: VirtualGoodType) -> VirtualGoodsViewController {
		switch type {
		case .stock:
			fatalError("Not implemented")
		case .virtualCoin:
			return VirtualGoodsEditableViewController(viewModel: cryptoCurrenciesViewModel)
		}
		
	}
}

