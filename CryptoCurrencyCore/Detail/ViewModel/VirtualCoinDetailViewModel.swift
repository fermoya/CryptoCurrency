//
//  DetailViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/21/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import CryptoCurrencyData
import CryptoCurrenciesWebservice
import Action
import Charts

class VirtualCoinDetailViewModel: DetailViewModel {
	
	private var repository: CryptoCurrenciesRepository
	private var dateFormatter: DateFormatter
	
	private(set) var currency: BehaviorSubject<Currency> = BehaviorSubject(value: .dollar)
	private(set) var recordPeriod: BehaviorSubject<RecordPeriod> = BehaviorSubject(value: .lastMonth)
	private(set) var virtualGood: ReplaySubject<VirtualGood> = ReplaySubject.create(bufferSize: 1)
	private(set) var chartType: BehaviorSubject<ChartType> = BehaviorSubject(value: .averagePrice)
	
	private var historicalRecord: Observable<[VirtualGoodRecordType]>
	private var period: Observable<Period>
	
	init(repository: CryptoCurrenciesRepository, dateFormatter: DateFormatter) {
		self.repository = repository
		self.dateFormatter = dateFormatter
		
		let responseObservable = Observable.combineLatest(virtualGood.asObservable(), currency.asObservable(), recordPeriod.asObservable())
			.flatMapLatest { combination -> Observable<CryptoCurrencyHistorialDataResponse> in
					let virtualGood = combination.0
					let currency = combination.1
					let period = combination.2
					return repository.fetch(type: CryptoCurrencyHistorialDataResponse.self,
											from: Endpoints.CryptoCurrencies.historicalData(fromSymbol: virtualGood.symbol,
																						toSymbol: currency.code,
																						limit: period.limit,
																						aggregate: period.aggregate))
			}.filter { $0.isOk }
			.share(replay: 1)

		
		self.historicalRecord = responseObservable.map { $0.contents }.map { $0!.box() }
		self.period = responseObservable.map { $0.period }
	}
	
	var periodFormatted: Observable<String> {
		return period.map { [unowned self] period in
			let from = self.dateFormatter.string(from: period.from)
			let to = self.dateFormatter.string(from: period.to)
			return "\(from) - \(to)"
		}
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
