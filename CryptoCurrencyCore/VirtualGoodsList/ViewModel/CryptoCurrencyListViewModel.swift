//
//  CryptoCurrenciesViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/14/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources
import CryptoCurrenciesWebservice
import CryptoCurrencyData

enum Currency: String {
	case dollar = "$"
	case euro = "€"
}

extension Currency {
	var code: String {
		switch self {
		case .dollar:
			return "USD"
		case .euro:
			return "EUR"
		}
	}
}

class CryptoCurrencyListViewModel: VirtualGoodsEditableViewModel {
	var items: ReplaySubject<[String : VirtualGood]> = ReplaySubject.create(bufferSize: 1)
	var currency = BehaviorSubject<Currency>(value: .dollar)
	
	private(set) var repository: CryptoCurrenciesRepository
	private(set) var disposeBag = DisposeBag()
	
	var isEditing: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	
	private var detailNavigator: DetailNavigator
	
	init(repository: CryptoCurrenciesRepository, detailNavigator: DetailNavigator) {
		self.detailNavigator = detailNavigator
		self.repository = repository
	}
	
	func price(of symbol: String) -> Observable<String>? {
		return currency.asObservable().flatMapLatest { [unowned self] currency in
			return self.repository.fetch(type: CryptoCurrencyPriceResponse.self, from: .price(fromSymbol: symbol, toSymbols: [currency.code]))
				.map { response in
					return response[currency.code]!
				}.map(String.init)
				.map { (text: String) -> String in
					return text + currency.rawValue
			}
		}
	}
	
	private var virtualCoins: Observable<[AnyVirtualGood]> {
		let savedCurrencies = UserDefaults.standard.rx.observe([String].self, UserDefaults.CurrenciesSaved)
			.flatMapLatest { currencySymbols -> Observable<[String]> in
				guard let currencySymbols = currencySymbols else { return Observable.just([]) }
				return Observable.just(currencySymbols)
			}
		
		return Observable.combineLatest(savedCurrencies, items)
			.flatMapLatest(findCoins)
			.map { $0.box() }
	}
	
	private var defaultVirtualCoins: Observable<[AnyVirtualGood]> {
		let coins = Observable.of(VirtualCoin.defaultSymbols)
		return Observable.combineLatest(coins, items)
			.flatMapLatest(findCoins)
			.map { $0.box() }
	}
	
	private func findCoins(named symbols: [String], in coins: [String: VirtualGood]) -> Observable<[VirtualGood]> {
		var results = [VirtualGood]()
		for symbol in symbols {
			if let coin = coins[symbol] {
				results.append(coin)
			}
		}
		
		return Observable.just(results)
	}
	
	var sectionedItems: Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> {
		let sectionDefaultCoins = defaultVirtualCoins.map { coins in return AnimatableVirtualCoinSection<AnyVirtualGood>(model: "Most Popular", items: coins) }
		let sectionSavedCoins = virtualCoins.map { coins in return AnimatableVirtualCoinSection<AnyVirtualGood>(model: "Following", items: coins) }
		
		return Observable.combineLatest([sectionDefaultCoins, sectionSavedCoins])
	}
	
	lazy var onRemove = Action<String, Void> { [unowned self] coinSymbol in
		self.removeCoin(withSymbol: coinSymbol)
		return Observable.empty()
	}
	
	private func removeCoin(withSymbol symbol: String) {
		guard let symbols = UserDefaults.standard.object(forKey: UserDefaults.CurrenciesSaved) as? [String] else { return }
		let index = symbols.index { $0 == symbol }
		
		guard let indexToRemove = index else { return }
		var newSymbols = symbols
		newSymbols.remove(at: indexToRemove)
		
		UserDefaults.standard.set(newSymbols, forKey: UserDefaults.CurrenciesSaved)
	}
	
	lazy var onTap = Action<AnyVirtualGood, Bool> { [unowned self] virtualCoin in
		return self.detailNavigator.navigate(type: .virtualCoin) { [unowned self] detailViewModel in
			self.currency.asObservable().bind(to: detailViewModel.currency).disposed(by: self.disposeBag)
			detailViewModel.virtualGood.onNext(virtualCoin)
		}.asObservable().map { _ in return false }
	}
	
	var canEditRowAtIndexPath: (TableViewSectionedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>, IndexPath) -> Bool = { (dataSource, indexPath) -> Bool in
		return indexPath.section != 0
	}
	
	var titleForHeaderInSection: (TableViewSectionedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>, Int) -> String? = { dataSource, index in
		let items = dataSource.sectionModels[index].items
		return items.isEmpty ? nil : dataSource.sectionModels[index].model
	}
	
}

extension VirtualCoin {
	static let defaultSymbols = ["BTC", "ETH", "XRP"]
}
