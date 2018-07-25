//
//  SearchCryptoCurrenciesAssembly.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/19/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrenciesWebservice

protocol SearchResultViewControllerProvider: class {
	func searchResultViewController(for type: VirtualGoodSearchType) -> VirtualGoodsSearchViewController
}

final class SearchAssembly {
	
	var viewModel: VirtualGoodsSearchViewModel {
		return CryptoCurrencySearchListViewModel()
	}
	
	var searchNavigator: SearchNavigator {
		return SearchNavigator(viewControllerProvider: self)
	}
	
	//TODO: View Models for Search
	
	private var webServiceAssembly: WebServiceAssembly
	private var virtualGoodsViewControllerProvider: VirtualGoodsViewControllerProvider
	
	init(webServiceAssembly: WebServiceAssembly, virtualGoodsViewControllerProvider: VirtualGoodsViewControllerProvider) {
		self.webServiceAssembly = webServiceAssembly
		self.virtualGoodsViewControllerProvider = virtualGoodsViewControllerProvider
	}
	
}

extension SearchAssembly: SearchResultViewControllerProvider {
	func searchResultViewController(for type: VirtualGoodSearchType) -> VirtualGoodsSearchViewController {
		return virtualGoodsViewControllerProvider.virtualGoodsViewController(for: type)
	}
	
}
