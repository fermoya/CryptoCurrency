//
//  Array+VirtualGoodRecordType.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/11/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

extension Array where Element == VirtualCoinRecord {
	
	func box() -> [VirtualCoinRecordAdapter] {
		var results = [VirtualCoinRecordAdapter]()
		forEach { results.append(VirtualCoinRecordAdapter(record: $0)) }
		return results
	}
	
}

extension Array where Element == StockRecord {
	
	func box(formater: DateFormatter) -> [StockRecordAdapter] {
		var results = [StockRecordAdapter]()
		forEach { results.append(StockRecordAdapter(record: $0, formater: formater)) }
		return results
	}
	
}
