//
//  SearchResultViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/19/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import CryptoCurrencyData
import CryptoCurrenciesWebservice
import Action

class CryptoCurrencySearchListViewModel: VirtualGoodsSearchViewModel {
	
	var currency: BehaviorSubject<Currency> = BehaviorSubject(value: .dollar)
	var items: ReplaySubject<[String : VirtualGood]> = ReplaySubject.create(bufferSize: 1)
	func price(of symbol: String) -> Observable<String>? { return nil }
	
	var query = ReplaySubject<String>.create(bufferSize: 1)
	
	var sectionedItems: Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> {
		let savedCurrencies = UserDefaults.standard.object(forKey: UserDefaults.CurrenciesSaved) as? [String] ?? []
		return query.asObservable().distinctUntilChanged().flatMapLatest { [unowned self] (typedText) -> Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> in
			guard !typedText.isEmpty else { return Observable.empty() }
			return self.items.debug("[items]", trimOutput: true)
				.asObservable()
				.map(Dictionary.init)
				.map { coins -> [String: AnyVirtualGood] in
					return coins.filter { $0.key.contains(typedText) }
				}.map { dictionary -> [String: AnyVirtualGood] in
					return dictionary.filter { !VirtualCoin.defaultSymbols.contains($0.key) }
				}.map { dictionary -> [String: AnyVirtualGood] in
					return dictionary.filter { !savedCurrencies.contains($0.key) }
				}.map { dictionary -> [AnyVirtualGood] in
					return dictionary.map { $0.value }
				}.map { (coins: [AnyVirtualGood]) -> [AnimatableVirtualCoinSection<AnyVirtualGood>] in
					return [AnimatableVirtualCoinSection<AnyVirtualGood>(model: "", items: coins)]
				}
			}
	}

	lazy var onTap: Action<AnyVirtualGood, Bool> = Action<AnyVirtualGood, Bool> { virtualCoin in
		return Single<Bool>.create { single -> Disposable in
			var savedCurrencies = UserDefaults.standard.object(forKey: UserDefaults.CurrenciesSaved) as? [String] ?? []
			savedCurrencies.append(virtualCoin.symbol)
			savedCurrencies.sort()
			UserDefaults.standard.set(savedCurrencies, forKey: UserDefaults.CurrenciesSaved)
			single(.success(true))
			
			return Disposables.create()
		}
	}
	
}
