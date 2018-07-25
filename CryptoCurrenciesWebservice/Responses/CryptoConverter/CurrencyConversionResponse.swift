//
//  CurrencyConversionResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public typealias CurrencyConversionResponse = [String: Float]

extension Dictionary: CurrencyConverterResponseType where Key == String, Value == Float {
	public var price: Float { return values.first! }
	public var fromSymbol: String { return String(keys.first!.split(separator: "_")[0]) }
	public var toSymbol: String { return String(keys.first!.split(separator: "_")[1]) }
}
