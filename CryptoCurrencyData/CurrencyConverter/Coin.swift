//
//  Coin.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct Coin: Equatable {
	public var name: String
	public var id: Int
	public var symbol: String
	
	public init(id: Int, name: String, symbol: String) {
		self.name = name
		self.id = id
		self.symbol = symbol
	}
	
	public static func == (lhs: Coin, rhs: Coin) -> Bool {
		return lhs.id == rhs.id
	}
	
}
