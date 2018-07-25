//
//  DetailViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData
import Charts
import RxSwift

enum RecordPeriod: Int {
	case lastMonth = 0
	case lastYear = 1
}

extension RecordPeriod {
	var limit: Int {
		switch self {
		case .lastMonth:
			return 31
		case .lastYear:
			return 122
		}
	}
	
	var aggregate: Int {
		switch self {
		case .lastMonth:
			return 1
		case .lastYear:
			return 3
		}
	}
}

enum ChartType: Int {
	case averagePrice = 0
	case highestPrice = 1
	case lowestPrice = 2
	case openingPrice = 3
	case closingPrice = 4
}

extension ChartType {
	var description: String {
		switch self {
		case .averagePrice:
			return "Average Price"
		case .lowestPrice:
			return "Lowest Price"
		case .highestPrice:
			return "Highest Price"
		case .openingPrice:
			return "Opening Price"
		case .closingPrice:
			return "Closing Price"
		}
	}
}

protocol DetailViewModel {
	var periodFormatted: Observable<String> { get }
	var chartEntries: Observable<[ChartDataEntry]> { get }
	
	var currency: BehaviorSubject<Currency> { get }
	var recordPeriod: BehaviorSubject<RecordPeriod> { get }
	var virtualGood: ReplaySubject<VirtualGood> { get }
	var chartType: BehaviorSubject<ChartType> { get }
}
