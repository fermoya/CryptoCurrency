//
//  StockSearchListViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/4/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import Action
import CryptoCurrenciesWebservice

class StockSearchListViewModel: VirtualGoodsSearchViewModel {
	var query: ReplaySubject<String> = ReplaySubject.create(bufferSize: 1)
	var currency: BehaviorSubject<Currency> = BehaviorSubject(value: .dollar)
	var items: ReplaySubject<[String : VirtualGood]> = ReplaySubject.create(bufferSize: 1)
	
	private var repository: StocksRepository
	private var detailNavigator: DetailNavigator
	private var disposeBag = DisposeBag()
	
	func price(of symbol: String) -> Observable<String>? { return nil }
	
	var sectionedItems: Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> {
		return query.asObservable().distinctUntilChanged()
			.flatMapLatest { [unowned self] text -> Observable<[String: VirtualGood]> in
				guard !text.isEmpty else { return Observable.empty() }
				return self.items.asObservable().map { (stocks: [String: VirtualGood]) -> [String: VirtualGood] in
					return stocks.filter { key, value in value.name.lowercased().starts(with: text.lowercased()) }
				}
			}
			.map(Dictionary.init)
			.map { ("", Array($0.values)) }
			.map(AnimatableVirtualCoinSection.init)
			.map { [$0] }
	}
	
	lazy var onTap = Action<AnyVirtualGood, Bool> { [unowned self] stock in
		return self.detailNavigator.navigate(type: .stock) { [unowned self] detailViewModel in
			self.currency.asObservable().bind(to: detailViewModel.currency).disposed(by: self.disposeBag)
			detailViewModel.virtualGood.onNext(stock)
		}.asObservable().map { _ in return false }
	}
	
	init(repository: StocksRepository, detailNavigator: DetailNavigator) {
		self.repository = repository
		self.detailNavigator = detailNavigator
	}

}
