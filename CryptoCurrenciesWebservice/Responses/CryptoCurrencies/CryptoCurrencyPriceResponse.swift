//
//  CryptoCurrencyPriceResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/19/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public typealias CryptoCurrencyPriceResponse = [String: Float]

extension Dictionary: VirtualCoinResponseType where Key == String, Value == Float { }
