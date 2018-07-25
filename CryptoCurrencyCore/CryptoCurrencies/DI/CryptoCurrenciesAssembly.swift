//
//  CryptoCurrenciesAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/13/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

final class CryptoCurrenciesAssembly {
	
	var viewController: UIViewController {
		return CryptoCurrenciesViewController(viewModel: viewModel, virtualGoodsNavigator: virtualGoodsAssembly.navigator, searchNavigator: searchAssembly.searchNavigator)
	}
	
	var viewModel: VirtualCoinViewModel {
		return VirtualCoinViewModel(repository: webServiceAssembly.cryptoCurrenciesRepository)
	}
	
	private var webServiceAssembly: WebServiceAssembly
	private var searchAssembly: SearchAssembly
	private var virtualGoodsAssembly: VirtualGoodsAssembly
	
	init(webServiceAssembly: WebServiceAssembly, searchAssembly: SearchAssembly, virtualGoodsAssembly: VirtualGoodsAssembly) {
		self.webServiceAssembly = webServiceAssembly
		self.searchAssembly = searchAssembly
		self.virtualGoodsAssembly = virtualGoodsAssembly
	}
	
}
