//
//  StocksViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/26/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import CryptoCurrencyData

class StocksViewController: UIViewController {
	
	@IBOutlet weak var marketsCollectionView: UICollectionView!
	@IBOutlet weak var popularStockListsCollectionView: UICollectionView!
	
	private(set) var viewModel: StocksViewModel
	private var searchNavigator: SearchNavigator
	private weak var searchBar: UISearchBar!
	private var marketDataSource: RxCollectionViewSectionedAnimatedDataSource<StockMarketSection>!
	private var popularMarketsDataSource: RxCollectionViewSectionedReloadDataSource<PopularMarketSection>!
	
	init(viewModel: StocksViewModel, searchNavigator: SearchNavigator) {
		self.viewModel = viewModel
		self.searchNavigator = searchNavigator
		super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
		
		let tabBarItem = UITabBarItem()
		tabBarItem.image = UIImage(named: "icon-tab-stock", in: Bundle(for: type(of: self)), compatibleWith: nil)
		tabBarItem.selectedImage = UIImage(named: "icon-tab-selected-stock", in: Bundle(for: type(of: self)), compatibleWith: nil)
		tabBarItem.tag = 1
		self.tabBarItem = tabBarItem
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setUpView()
		bindViewModel()
    }

}

extension StocksViewController: Bindable {
	typealias ViewModel = StocksViewModel
	
	func setUpView() {
		marketsCollectionView.register(UINib(nibName: "MarketCollectionViewCell", bundle: Bundle(for: MarketCollectionViewCell.self)), forCellWithReuseIdentifier: "MarketCollectionViewCell")
		popularStockListsCollectionView.register(UINib(nibName: "PopularStockListCollectionViewCell", bundle: Bundle(for: PopularStockListCollectionViewCell.self)), forCellWithReuseIdentifier: "PopularStockListCollectionViewCell")

		marketsCollectionView.delegate = self
		popularStockListsCollectionView.delegate = self
		
		marketsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
		popularStockListsCollectionView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
		
		marketDataSource = RxCollectionViewSectionedAnimatedDataSource<StockMarketSection>(configureCell: { (dataSource, collectionView, indexPath, market) -> UICollectionViewCell in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
			cell.bind(to: market)
			return cell
		}, configureSupplementaryView: { (dataSource, colletionView, title, indexPath) -> UICollectionReusableView in
			return UICollectionReusableView()
		})
		
		popularMarketsDataSource = RxCollectionViewSectionedReloadDataSource<PopularMarketSection>.init(configureCell: { (dataSource, collectionView, indexPath, popularMarket) -> UICollectionViewCell in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularStockListCollectionViewCell", for: indexPath) as! PopularStockListCollectionViewCell
			cell.bind(to: popularMarket)
			return cell
		})
		
		searchBar = searchNavigator.installSearch(over: self, type: .stock, binding: bindSearch)
	}
	
	func bindSearch(searchViewModel: VirtualGoodsSearchViewModel) {
		viewModel.stocks.map { $0.box() }
			.bind(to: searchViewModel.items)
			.disposed(by: rx.disposeBag)
	}
	
	func bindViewModel() {
		viewModel.marketsSecionedObservable
			.bind(to: marketsCollectionView.rx.items(dataSource: marketDataSource))
			.disposed(by: rx.disposeBag)
		
		viewModel.popularMarketsSectionedObservable
			.bind(to: popularStockListsCollectionView.rx.items(dataSource: popularMarketsDataSource))
			.disposed(by: rx.disposeBag)
	}
	
}

extension StocksViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView == marketsCollectionView {
			return CGSize(width: 120, height: collectionView.frame.height)
		} else {
			let screenWidth = UIScreen.main.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
			return CGSize(width: screenWidth / 2, height: 200)
		}
	}
	
}
