//
//  StockLogoResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 7/6/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public typealias StockLogoResponse = [String: String]

extension Dictionary: StocksResponseType where Key == String, Value == String {
	public var logo: String? {
		return self["url"]
	}
}
