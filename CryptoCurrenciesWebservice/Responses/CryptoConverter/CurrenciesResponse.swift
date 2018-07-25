//
//  CurrenciesResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

public struct CurrenciesResponse {
	public var coins: [Coin]
}

extension CurrenciesResponse: Decodable {
	private enum CodingKeys: String, CodingKey {
		case results
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		let results = try? container.decode([String: [String: String]].self, forKey: .results)
		var coins = [Coin]()
		results?.forEach({ (key, value) in
			let name = value["currencyName"]!
			let symbol = key
			let id = key.hashValue
			coins.append(Coin(id: id, name: name, symbol: symbol))
		})
		
		self.coins = coins
	}
}

extension CurrenciesResponse: CurrencyConverterResponseType {  }
