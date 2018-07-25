//
//  VirtualCoinViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/3/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData
import CryptoCurrenciesWebservice
import RxSwift

class VirtualCoinViewModel {
	private(set) var repository: CryptoCurrenciesRepository
	private(set) var cryptoCurrencies: Observable<[String: VirtualCoin]>
	private(set) var disposeBag = DisposeBag()
	
	init(repository: CryptoCurrenciesRepository) {
		self.repository = repository
		cryptoCurrencies = repository.fetch(type: CryptoCurrenciesResponse.self, from: .list)
			.filter { $0.isOk }
			.map { $0.contents }
			.share(replay: 1, scope: .whileConnected)
	}
	
}
