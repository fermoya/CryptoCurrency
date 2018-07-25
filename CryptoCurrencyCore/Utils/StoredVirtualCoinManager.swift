//
//  StoredVirtualCoinManager.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/20/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import Action
import CryptoCurrencyData

class StoredVirtualCoinManager: NSObject {

	var onRemoveVirtualCoin
	
	func removeCoin(withSymbol symbol: String) {
		guard let symbols = UserDefaults.standard.object(forKey: UserDefaults.CurrenciesSaved) as? [String] else { return }
		let index = symbols.index { $0 == symbol }
		
		guard let indexToRemove = index else { return }
		var newSymbols = symbols
		newSymbols.remove(at: indexToRemove)
		
		UserDefaults.standard.set(newSymbols, forKey: UserDefaults.CurrenciesSaved)
	}
	
}
