//
//  StocksWebServiceTests.swift
//  CryptoCurrenciesWebserviceTests
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import CryptoCurrencyData
@testable import CryptoCurrenciesWebservice

class StocksWebServiceTests: XCTestCase {
    
	var scheduler: ConcurrentDispatchQueueScheduler!
	
	override func setUp() {
		super.setUp()
		scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
	}
    
    func test_listStocks() {
        let webService = StocksRepository()
		let stocksObservable = webService.fetch(type: StocksResponse.self, from: .list).subscribeOn(scheduler)
		
		let results = try! stocksObservable.toBlocking().first()
		XCTAssertNotNil(results)
		XCTAssertFalse(results!.isEmpty)
    }
	
	func test_listMarkets() {
		let webService = StocksRepository()
		let marketsObservable = webService.fetch(type: MarketsResponse.self, from: .markets).subscribeOn(scheduler)
		
		let results = try! marketsObservable.toBlocking().first()
		XCTAssertNotNil(results)
		XCTAssertFalse(results!.isEmpty)
	}
	
	func test_fetchLogo() {
		let webService = StocksRepository()
		let logoObservable = webService.fetch(type: StockLogoResponse.self, from: .logo("AAPL")).subscribeOn(scheduler)
		
		let results = try! logoObservable.toBlocking().first()
		XCTAssertNotNil(results)
		XCTAssertNotNil(results!.logo)
		XCTAssertFalse(results!.logo!.isEmpty)
	}
	
	func test_fetchRecords() {
		let webService = StocksRepository()
		let logoObservable = webService.fetch(type: StockHistoricalDataResponse.self, from: Endpoints.Stocks.historicalData(last: "1m", fromSymbol: "aapl")).subscribeOn(scheduler)
		
		let results = try! logoObservable.toBlocking().first()
		XCTAssertNotNil(results)
		XCTAssertFalse(results!.isEmpty)
	}
	
}
