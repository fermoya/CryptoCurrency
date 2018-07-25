//
//  WebServiceAssembly.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/18/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public class WebServiceAssembly {
	
	public private(set) lazy var cryptoCurrenciesRepository = CryptoCurrenciesRepository()
	public private(set) lazy var stocksRepository = StocksRepository()
	public private(set) lazy var currencyConverterRepository = CurrencyConverterRepository()
	
	public private(set) lazy var dateFormatter: DateFormatter = { _ in
		let dateFormatter = DateFormatter.init()
		dateFormatter.dateFormat = "dd/MM/yy"
		return dateFormatter
	}(self)
	
	public private(set) lazy var stockDateFormatter: DateFormatter = { _ in
		let dateFormatter = DateFormatter.init()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}(self)
	
	public init() { }
}
