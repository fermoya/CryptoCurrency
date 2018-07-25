//
//  SearchNavigator.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/19/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class SearchNavigator {
	
	private weak var viewControllerProvider: SearchResultViewControllerProvider!
	private var searchController: UISearchController!
	
	init(viewControllerProvider: SearchResultViewControllerProvider) {
		self.viewControllerProvider = viewControllerProvider
	}
	
	func installSearch(over viewController: UIViewController, type: VirtualGoodSearchType, binding: (VirtualGoodsSearchViewModel) -> Void) -> UISearchBar {
		let resultsViewController = viewControllerProvider.searchResultViewController(for: type)
		searchController = UISearchController(searchResultsController: resultsViewController)
		resultsViewController.searchBar = searchController.searchBar
		
		searchController.searchResultsUpdater = resultsViewController
		searchController.searchBar.autocapitalizationType = .allCharacters
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.searchBarStyle = .minimal
		
		viewController.navigationItem.titleView = searchController.searchBar
		viewController.definesPresentationContext = true
		
		binding(resultsViewController.searchViewModel)
		
		return searchController.searchBar
	}
	
}
