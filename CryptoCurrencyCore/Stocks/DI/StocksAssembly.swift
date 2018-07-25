//
//  StocksAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

final class StocksAssembly {
	
	var viewModel: StocksViewModel {
		return StocksViewModel(repository: webServiceAssembly.stocksRepository, detailNavigator: detailAssembly.detailStockNavigator)
	}
	
	var viewController: UIViewController {
		return StocksViewController(viewModel: viewModel, searchNavigator: searchAssembly.searchNavigator)
	}
	
	private var webServiceAssembly: WebServiceAssembly
	private var searchAssembly: SearchAssembly
	private var detailAssembly: DetailAssembly
	
	init(searchAssembly: SearchAssembly, webServiceAssembly: WebServiceAssembly, detailAssembly: DetailAssembly) {
		self.webServiceAssembly = webServiceAssembly
		self.searchAssembly = searchAssembly
		self.detailAssembly = detailAssembly
	}
	
}
