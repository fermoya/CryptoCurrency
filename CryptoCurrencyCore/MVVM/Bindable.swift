//
//  Bindable.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/18/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

protocol Bindable {
	associatedtype ViewModel
	var viewModel: ViewModel { get }
	
	func setUpView()
	func bindViewModel()
}
