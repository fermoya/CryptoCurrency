//
//  CoinRecord.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct CoinRecord {
	public var date: Date
	public var price: Float
	
	public init(date: Date, price: Float) {
		self.date = date
		self.price = price
	}
}
