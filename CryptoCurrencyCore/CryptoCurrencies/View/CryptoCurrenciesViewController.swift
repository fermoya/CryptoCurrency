//
//  CryptoCurrenciesViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/14/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import CryptoCurrencyData

final class CryptoCurrenciesViewController: UIViewController {
	
	@IBOutlet weak var currenciesTableViewContainer: UIView!
	
	private var virtualGoodsNavigator: VirtualGoodsNavigator
	private var searchNavigator: SearchNavigator
	private var viewModel: VirtualCoinViewModel
	
	private var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>!
	private var editBarButtonItem: UIBarButtonItem
	private var currencyBarButtonItem: UIBarButtonItem
	private weak var searchBar: UISearchBar!
	
	init(viewModel: VirtualCoinViewModel, virtualGoodsNavigator: VirtualGoodsNavigator, searchNavigator: SearchNavigator) {
		self.virtualGoodsNavigator = virtualGoodsNavigator
		self.searchNavigator = searchNavigator
		self.viewModel = viewModel
		editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
		currencyBarButtonItem = UIBarButtonItem(title: "€", style: .plain, target: nil, action: nil)
		
		super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		print("CryptoCurrencies shown")
		setUpView()
		bindViewModel()
    }
	
	func setUpView() {
		navigationItem.rightBarButtonItem = editBarButtonItem
		navigationItem.leftBarButtonItem = currencyBarButtonItem

		let virtualCoinTabBarItem = UITabBarItem()
		virtualCoinTabBarItem.image = UIImage(named: "icon-tab-bitcoin", in: Bundle(for: type(of: self)), compatibleWith: nil)
		virtualCoinTabBarItem.selectedImage = UIImage(named: "icon-tab-selected-bitcoin", in: Bundle(for: type(of: self)), compatibleWith: nil)
		virtualCoinTabBarItem.tag = 0
		parent?.tabBarItem = virtualCoinTabBarItem
		
		searchBar = searchNavigator.installSearch(over: self, type: .virtualCoin, binding: bindSearch)
		virtualGoodsNavigator.install(over: self, in: currenciesTableViewContainer, type: .virtualCoin, binding: bindList)
	}
	
	func bindList(to virtualGoodsViewModel: VirtualGoodsViewModel) {
		guard let editableViewModel = virtualGoodsViewModel as? VirtualGoodsEditableViewModel else { return }
		
		editBarButtonItem.rx.tap.enumerated()
			.map { $0.index % 2 == 0 }
			.bind(to: editableViewModel.isEditing)
			.disposed(by: rx.disposeBag)
		
		currencyBarButtonItem.rx.tap.enumerated()
			.map { $0.index % 2 == 0 ? Currency.euro : Currency.dollar }
			.bind(to: virtualGoodsViewModel.currency)
			.disposed(by: rx.disposeBag)
		
		viewModel.cryptoCurrencies
			.map { $0.box() }
			.bind(to: virtualGoodsViewModel.items)
			.disposed(by: rx.disposeBag)
	}
	
	func bindSearch(searchViewModel: VirtualGoodsSearchViewModel) {
		self.viewModel.cryptoCurrencies
			.map { $0.box() }
			.bind(to: searchViewModel.items)
			.disposed(by: rx.disposeBag)
	}
	
	func bindViewModel() {
		editBarButtonItem.rx.tap
			.enumerated()
			.map { $0.index % 2 == 1 ? "Edit" : "Done" }
			.bind(to: editBarButtonItem.rx.title)
			.disposed(by: rx.disposeBag)
		
		currencyBarButtonItem.rx.tap
			.enumerated()
			.map { $0.index % 2 == 0 ? "$" : "€" }
			.bind(to: currencyBarButtonItem.rx.title)
			.disposed(by: rx.disposeBag)
		
		searchBar.rx.textDidBeginEditing
			.map { _ in return false }
			.bind(to: editBarButtonItem.rx.isEnabled)
			.disposed(by: rx.disposeBag)
		
		searchBar.rx.cancelButtonClicked
			.map { _ in return true }
			.bind(to: editBarButtonItem.rx.isEnabled)
			.disposed(by: rx.disposeBag)
		
		searchBar.rx.textDidEndEditing
			.map { _ in return true }
			.bind(to: editBarButtonItem.rx.isEnabled)
			.disposed(by: rx.disposeBag)
	}
	
}

