//
//  StockListViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/3/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import CryptoCurrenciesWebservice
import RxDataSources
import Action
import NSObject_Rx
import CryptoCurrencyData

enum StockMarketType: String {
	case gaining
	case losing
	case mostActive
	case greatestAbsoluteVolume
	case greatestRelativeVolume
}

class StockListViewModel: NSObject, VirtualGoodsViewModel {
	//** Idle, not used */
	var items: ReplaySubject<[String : VirtualGood]> = ReplaySubject.create(bufferSize: 0)
	var currency: BehaviorSubject<Currency> = BehaviorSubject(value: .dollar)
	
	private(set) var repository: StocksRepository
	private(set) var disposeBag = DisposeBag()
	private var detailNavigator: DetailNavigator
	
	private(set) var stockMarketItems: Observable<[Stock]>
	var marketType: ReplaySubject<StockMarketType> = ReplaySubject.create(bufferSize: 1)

	init(repository: StocksRepository, detailNavigator: DetailNavigator) {
		self.detailNavigator = detailNavigator
		self.repository = repository
		
		stockMarketItems = marketType.asObservable().map { marketType -> Endpoints.Stocks in
				switch marketType {
				case .gaining:
					return Endpoints.Stocks.gainers
				case .losing:
					return Endpoints.Stocks.losers
				case .greatestAbsoluteVolume:
					return Endpoints.Stocks.stockVolume
				case .greatestRelativeVolume:
					return Endpoints.Stocks.stockPercent
				case .mostActive:
					return Endpoints.Stocks.mostactive
				}
			}.flatMapLatest { (endpoint) -> Observable<[Stock]> in
				return repository.fetch(type: StocksResponse.self, from: endpoint)
			}
	}
	
	lazy var onTap = Action<AnyVirtualGood, Bool> { [unowned self] stock in
		return Observable.just(false)
	}
	
	var sectionedItems: Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> {
		return items.asObservable()
			.map(Dictionary.init)
			.map { Array($0.values) }
			.map { ("", $0) }
			.map(AnimatableVirtualCoinSection.init)
			.map { [$0] }
	}
	
	func price(of symbol: String) -> Observable<String>? { return nil }
}
