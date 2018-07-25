//
//  CurrencyHistoricalDataResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

public typealias CurrencyHistoricalDataResponse = [String: [String: Float]]

extension Dictionary where Key == String, Value == [String: Float] {
	
	public var records: [CoinRecord] {
		var count: Float = 0
		var results = values.first!.reduce([], { (results, entry) -> [CoinRecord] in
			let dateFormatter = DateFormatter()
			dateFormatter.calendar = Calendar(identifier: .gregorian)
			dateFormatter.dateFormat = "yyyy-MM-dd"
			
			var newResults = results
			newResults.append(CoinRecord(date: dateFormatter.date(from: entry.key)!, price: entry.value))
			count = count + 1
			return newResults
		})
		results.sort { coin1, coin2 -> Bool in
			coin2.date > coin1.date
		}
		return results
	}
	
}
