//
//  CoinDetailViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData
import CryptoCurrenciesWebservice
import RxSwift
import Charts

class StockDetailViewModel: DetailViewModel {
	
	private(set) var currency: BehaviorSubject<Currency> = BehaviorSubject(value: .dollar)
	private(set) var recordPeriod: BehaviorSubject<RecordPeriod> = BehaviorSubject(value: .lastMonth)
	private(set) var virtualGood: ReplaySubject<VirtualGood> = ReplaySubject.create(bufferSize: 1)
	private(set) var chartType: BehaviorSubject<ChartType> = BehaviorSubject(value: .averagePrice)
	
	private var historicalRecord: Observable<[VirtualGoodRecordType]>
	private var period: Observable<Period> {
		return historicalRecord.flatMap { periods -> Observable<Period> in
			let firstPeriod = periods.first!
			let lastPeriod = periods.last!
			
			return Observable.just(Period(from: firstPeriod.date,
										  to: lastPeriod.date))
		}
	}
	var periodFormatted: Observable<String> { return Observable<String>.empty() }

	private var repository: StocksRepository
	private var dateFormater: DateFormatter
	
	init(repository: StocksRepository, dateFormater: DateFormatter) {
		self.repository = repository
		self.dateFormater = dateFormater
		
		self.historicalRecord = Observable.combineLatest(virtualGood.asObservable(), currency.asObservable(), recordPeriod.asObservable())
			.map { combination -> (VirtualGood?, Currency, String) in
				let code = combination.2 == RecordPeriod.lastYear ? "1y" : "1m"
				return (combination.0, combination.1, code)
			}.filter { $0.0 != nil }
			.flatMapLatest { combination -> Observable<StockHistoricalDataResponse> in
				let virtualGood = combination.0!
				let period = combination.2
				return repository.fetch(type: StockHistoricalDataResponse.self,
										from: Endpoints.Stocks.historicalData(last: period, fromSymbol: virtualGood.symbol))
			}.map { $0.box(formater: dateFormater) }
			.share(replay: 1)
	}
	
	private var averageCharEntries: Observable<[ChartDataEntry]> {
		return historicalRecord
			.map { (records: [VirtualGoodRecordType]) -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { (record: VirtualGoodRecordType) in
					entries.append(ChartDataEntry(x: Double(record.date.timeIntervalSince1970), y: Double(record.price)))
				}
				return entries
		}
	}
	
	private var lowestPriceCharEntries: Observable<[ChartDataEntry]> {
		return historicalRecord
			.map { (records: [VirtualGoodRecordType]) -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { (record: VirtualGoodRecordType) in
					entries.append(ChartDataEntry(x: Double(record.date.timeIntervalSince1970), y: Double(record.lowestPrice)))
				}
				return entries
		}
	}
	
	private var highestPriceCharEntries: Observable<[ChartDataEntry]> {
		return historicalRecord
			.map { (records: [VirtualGoodRecordType]) -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { (record: VirtualGoodRecordType) in
					entries.append(ChartDataEntry(x: Double(record.date.timeIntervalSince1970), y: Double(record.highestPrice)))
				}
				return entries
		}
	}
	
	private var openingPriceCharEntries: Observable<[ChartDataEntry]> {
		return historicalRecord
			.map { (records: [VirtualGoodRecordType]) -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { (record: VirtualGoodRecordType) in
					entries.append(ChartDataEntry(x: Double(record.date.timeIntervalSince1970), y: Double(record.firstPrice)))
				}
				return entries
		}
	}
	
	private var closingPriceCharEntries: Observable<[ChartDataEntry]> {
		return historicalRecord
			.map { (records: [VirtualGoodRecordType]) -> [ChartDataEntry] in
				var entries = [ChartDataEntry]()
				records.forEach { (record: VirtualGoodRecordType) in
					entries.append(ChartDataEntry(x: Double(record.date.timeIntervalSince1970), y: Double(record.lastPrice)))
				}
				return entries
		}
	}
	
	lazy var chartEntries: Observable<[ChartDataEntry]> = { this in
		return Observable.combineLatest(chartType.asObservable(), recordPeriod.asObservable()).flatMapLatest({ [unowned self] type, _ -> Observable<[ChartDataEntry]> in
			switch type {
			case .averagePrice:
				return this.averageCharEntries
			case .closingPrice:
				return this.closingPriceCharEntries
			case .highestPrice:
				return this.highestPriceCharEntries
			case .lowestPrice:
				return this.lowestPriceCharEntries
			case .openingPrice:
				return this.openingPriceCharEntries
			}
		}).share(replay: 1)
	}(self)
	
}
