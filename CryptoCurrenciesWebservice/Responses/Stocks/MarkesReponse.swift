//
//  MarkesReponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

public typealias MarketsResponse = [StockMarket]

extension Array: StocksResponseType where Element == StockMarket {  }
