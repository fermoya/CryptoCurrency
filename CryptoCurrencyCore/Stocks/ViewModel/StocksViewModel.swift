//
//  StocksViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import CryptoCurrenciesWebservice
import RxDataSources
import Action
import NSObject_Rx
import CryptoCurrencyData

typealias StockMarketSection = AnimatableSectionModel<String, StockMarket>
typealias PopularMarketSection = SectionModel<String, PopularMarket>

class StocksViewModel: NSObject {
	
	private var repository: StocksRepository
	private var detailNavigator: DetailNavigator
	
	private var markets: Observable<MarketsResponse>
	private(set) var stocks: Observable<[String: Stock]>!
	
	var popularMarketsSectionedObservable: Observable<[PopularMarketSection]> {
		return Observable.just(PopularMarket.default).map { return [PopularMarketSection(model: "Popular Stock Markets", items: $0)] }
	}
	
	var marketsSecionedObservable: Observable<[StockMarketSection]> {
		return markets.asObservable()
			.map { return [AnimatableSectionModel(model: "Open Markets", items: $0)] }
			.share(replay: 1, scope: .whileConnected)
	}
	
	private func image(of symbol: String) -> Observable<String> {
		return repository.fetch(type: StockLogoResponse.self, from: .logo(symbol)).map { $0.logo }.filter { $0 != nil }.map { $0! }
	}
	
	init(repository: StocksRepository, detailNavigator: DetailNavigator) {
		self.repository = repository
		self.detailNavigator = detailNavigator
		
		let marketsObservable = repository.fetch(type: MarketsResponse.self, from: .markets)
		markets = Observable<Int>.interval(60, scheduler: MainScheduler.instance)
			.startWith(-1)
			.flatMapLatest { _ in return marketsObservable }
		
		super.init()
		
		stocks = repository.fetch(type: StocksResponse.self, from: .list)
			.map { $0.toDict() }
			.share(replay: 1)
	}
	
}

extension StockMarket: IdentifiableType {
	public var identity: String {
		return "\(name)-\(incrementPercentage)"
	}
	
	public typealias Identity = String
}
