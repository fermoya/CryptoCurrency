//
//  Array+StockResponse.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/4/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

extension Array where Element == Stock {
	
	func toDict() -> [String: Stock] {
		var results = [String: Stock]()
		forEach { results[$0.symbol] = $0 }
		return results
	}
	
}
