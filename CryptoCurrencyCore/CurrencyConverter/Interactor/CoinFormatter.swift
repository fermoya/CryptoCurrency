//
//  CoinFormatter.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

extension Coin {
	static let None = Coin(id: -1, name: "None", symbol: "NONE")
}

class CoinFormatter {
	
	func fullName(of coin: Coin) -> String {
		guard coin != Coin.None else { return coin.name }
		return "\(coin.name)(\(coin.symbol))"
	}
	
	func shortName(from coinFullName: String) -> String {
		guard coinFullName != fullName(of: Coin.None) else { return Coin.None.name }
		
		let end = coinFullName.index(of: "(")!
		return String(coinFullName[coinFullName.startIndex..<end])
	}
	
	func symbol(from coinFullName: String) -> String {
		guard coinFullName != fullName(of: Coin.None) else { return Coin.None.name }
		
		let start = coinFullName.index(after: coinFullName.index(of: "(")!)
		let end = coinFullName.index(of: ")")!
		return String(coinFullName[start..<end])
	}
	
}
