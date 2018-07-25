//
//  CurrencyConverterWebServiceTest.swift
//  CryptoCurrenciesWebserviceTests
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
import CryptoCurrencyData
@testable import CryptoCurrenciesWebservice

class CurrencyConverterWebServiceTest: XCTestCase {
	
	var scheduler: ConcurrentDispatchQueueScheduler!
	var assembly = WebServiceAssembly()
	
    override func setUp() {
        super.setUp()
		scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
	func test_fetchCurrencies() {
        let repository = assembly.currencyConverterRepository
		let currencyConverterObservable = repository.fetch(type: CurrenciesResponse.self, from: .list).subscribeOn(scheduler)
		
		let response = try! currencyConverterObservable.toBlocking().first()
		XCTAssertNotNil(response)
		XCTAssertFalse(response!.coins.isEmpty)
    }
	
	func test_fetchCurrentPrice() {
		let repository = assembly.currencyConverterRepository
		let currencyConverterObservable = repository.fetch(type: CurrencyConversionResponse.self, from: .convert(fromSymbol: "EUR", toSymbol: "USD")).subscribeOn(scheduler)
		
		let response = try! currencyConverterObservable.toBlocking().first()
		XCTAssertNotNil(response)
		XCTAssertFalse(response!.fromSymbol.isEmpty)
		XCTAssertFalse(response!.toSymbol.isEmpty)
		XCTAssertTrue(response!.price > 0)
	}
	
	func test_fetchHistoricalData() {
		let repository = assembly.currencyConverterRepository
		let currencyConverterObservable = repository.fetch(type: CurrencyHistoricalDataResponse.self, from: .last8Days(fromSymbol: "EUR", toSymbol: "USD")).subscribeOn(scheduler)
		
		let response = try! currencyConverterObservable.toBlocking().first()
		XCTAssertNotNil(response)
		XCTAssertFalse(response!.records.isEmpty)
	}
    
}
