//
//  VirtualGoodRecord.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/11/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

protocol VirtualGoodRecordType {
	var date: Date { get }
	var price: Float { get }
	var highestPrice: Float { get }
	var lowestPrice: Float { get }
	var firstPrice: Float { get }
	var lastPrice: Float { get }
}

class VirtualCoinRecordAdapter: VirtualGoodRecordType {
	
	private var record: VirtualCoinRecord
	
	init(record: VirtualCoinRecord) {
		self.record = record
	}
	
	var date: Date { return Date(timeIntervalSince1970: TimeInterval(record.date)) }
	var price: Float { return record.price }
	var highestPrice: Float { return record.highestPrice }
	var lowestPrice: Float { return record.lowestPrice }
	var firstPrice: Float { return record.firstPrice }
	var lastPrice: Float { return record.lastPrice }
	
}

class StockRecordAdapter: VirtualGoodRecordType {
	
	private var record: StockRecord
	private var formater: DateFormatter
	
	init(record: StockRecord, formater: DateFormatter) {
		self.record = record
		self.formater = formater
	}
	
	var date: Date { return formater.date(from: record.date)! }
	var price: Float { return record.price }
	var highestPrice: Float { return record.highestPrice }
	var lowestPrice: Float { return record.lowestPrice }
	var firstPrice: Float { return record.firstPrice }
	var lastPrice: Float { return record.lastPrice }
	
}
