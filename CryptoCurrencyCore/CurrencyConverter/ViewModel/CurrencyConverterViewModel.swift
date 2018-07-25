//
//  CurrencyConverterViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import NSObject_Rx
import RxSwift
import CryptoCurrencyData
import Charts
import CryptoCurrenciesWebservice

class CurrencyConverterViewModel: NSObject {
	
	private var webService: CurrencyConverterRepository
	
	var coins: Observable<[Coin]>
	var coinNames: Observable<[String]> {
		return coins.map { $0.map { CoinFormatter().fullName(of: $0) } }
			.map { coinNames in
				return coinNames.sorted(by: { (name1, name2) -> Bool in
					name2 > name1
				})
			}.map{ coinNames -> [String] in
				var newCoinsNames = coinNames
				newCoinsNames.insert(CoinFormatter().fullName(of: Coin.None), at: 0)
				return newCoinsNames
			}
	}
	
	init(webService: CurrencyConverterRepository) {
		self.webService = webService
		coins = webService.fetch(type: CurrenciesResponse.self, from: .list)
			.map { $0.coins }
			.share(replay: 1, scope: .whileConnected)
		
		super.init()
	}
	
	func chart(for symbol: String, with base: String) -> Observable<[ChartDataEntry]> {
		let coinFormatter = CoinFormatter()
		let from = coinFormatter.symbol(from: symbol)
		let to = coinFormatter.symbol(from: base)
		
		return webService
			.fetch(type: CurrencyHistoricalDataResponse.self, from: .last8Days(fromSymbol: from, toSymbol: to))
			.map { $0.records }
			.map { records -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { record in
					return entries.append(
						ChartDataEntry(
							x: Double(record.date.timeIntervalSince1970),
							y: Double(record.price)))
					
				}
				return entries
			}.share(replay: 1, scope: .whileConnected)
	}
	
}
