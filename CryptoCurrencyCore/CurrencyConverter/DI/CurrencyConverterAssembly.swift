//
//  CurrencyConverterAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

final class CurrencyConverterAssembly {
	
	var viewModel: CurrencyConverterViewModel {
		return CurrencyConverterViewModel(webService: webServiceAssembly.currencyConverterRepository)
	}
	
	var viewController: UIViewController {
		return CurrencyConverterViewController(viewModel: viewModel)
	}
	
	private var webServiceAssembly: WebServiceAssembly
	
	init(webServiceAssembly: WebServiceAssembly) {
		self.webServiceAssembly = webServiceAssembly
	}
	
}
