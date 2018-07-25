//
//  VirtualGoodsSearchViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/3/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift

class VirtualGoodsSearchViewController: VirtualGoodsViewController {
	
	private(set) var searchViewModel: VirtualGoodsSearchViewModel
	weak var searchBar: UISearchBar!
	
	init(viewModel: VirtualGoodsSearchViewModel) {
		self.searchViewModel = viewModel
		super.init(viewModel: viewModel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func bindViewModel() {
		super.bindViewModel()

		viewModel.onTap.elements
			.filter { $0 }
			.subscribe(onNext: { [unowned self] _ in
				self.searchBar.text = ""
				self.dismiss(animated: true)
			}).disposed(by: rx.disposeBag)
	}
	
}

extension VirtualGoodsSearchViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text, !text.isEmpty {
			searchViewModel.query.onNext(searchController.searchBar.text ?? "")
		}
	}
}
