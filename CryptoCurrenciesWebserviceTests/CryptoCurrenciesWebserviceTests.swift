//
//  CryptoCurrenciesWebserviceTests.swift
//  CryptoCurrenciesWebserviceTests
//
//  Created by Fernando Moya de Rivas on 6/15/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import CryptoCurrencyData
@testable import CryptoCurrenciesWebservice

class CryptoCurrenciesWebserviceTests: XCTestCase {
	
	var scheduler: ConcurrentDispatchQueueScheduler!
	
    override func setUp() {
        super.setUp()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    }
	
    func test_cryptoCurrenciesNotNil() {
		let webService = CryptoCurrenciesRepository()
		let webServiceResponseObservable = webService.fetch(type: CryptoCurrenciesResponse.self, from: .list).subscribeOn(scheduler)
		
		let result = try! webServiceResponseObservable.toBlocking().first()
		XCTAssertNotNil(result)
		XCTAssertTrue(result!.isOk)
		XCTAssertFalse(result!.contents.isEmpty)
    }
	
	func test_cryptoCurrencyPriceNotNil() {
		
		let webService = CryptoCurrenciesRepository()
		let webServiceResponseObservable = webService.fetch(type: CryptoCurrencyPriceResponse.self, from: .price(fromSymbol: "ETH", toSymbols: ["USD", "EUR"])).subscribeOn(scheduler)
		
		let result = try! webServiceResponseObservable.toBlocking().first()
		XCTAssertNotNil(result)
		XCTAssertFalse(result!.isEmpty)
		XCTAssertNotNil(result!["USD"])
		XCTAssertNotNil(result!["EUR"])
	}
	
	func test_cryptoCurrencyHistoricalRecordNotNil() {
		let webService = CryptoCurrenciesRepository()
		let webServiceResponseObservable =
			webService.fetch(type: CryptoCurrencyHistorialDataResponse.self, from: .historicalData(
				fromSymbol: "BTC",
				toSymbol: "USD",
				limit: 60,
				aggregate: 1)).subscribeOn(scheduler)
		
		let result = try! webServiceResponseObservable.toBlocking().first()
		XCTAssertNotNil(result)
		XCTAssertTrue(result!.isOk)
		XCTAssertFalse(result!.contents.isEmpty)
	}
	
}
