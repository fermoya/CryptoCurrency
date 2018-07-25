//
//  VirtualGoodsViewModel.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData
import RxDataSources
import RxSwift
import Action

struct AnimatableVirtualCoinSection<T: VirtualGood & IdentifiableType & Equatable> {
	var model: String
	var items: [T]
	
	init(model: String, items: [T]) {
		self.model = model
		self.items = items
	}
}

extension AnimatableVirtualCoinSection: AnimatableSectionModelType {
	
	init(original: AnimatableVirtualCoinSection<T>, items: [T]) {
		self = original
		self.items = items
	}
	
	typealias Identity = String
	
	var identity: String {		
		return model
	}
}

protocol VirtualGoodsViewModel {
	// List
	var currency: BehaviorSubject<Currency> { get }
	var items: ReplaySubject<[String: VirtualGood]> { get }
	func price(of symbol: String) -> Observable<String>?
	var sectionedItems: Observable<[AnimatableVirtualCoinSection<AnyVirtualGood>]> { get }

	// Interaction
	var onTap: Action<AnyVirtualGood, Bool> { get }
}

protocol VirtualGoodsEditableViewModel: VirtualGoodsViewModel {
	var isEditing: BehaviorSubject<Bool> { get }
	var canEditRowAtIndexPath: (TableViewSectionedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>, IndexPath) -> Bool { get }
	var titleForHeaderInSection: (TableViewSectionedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>, Int) -> String? { get }
	var onRemove: Action<String, Void> { get }
}

protocol VirtualGoodsSearchViewModel: VirtualGoodsViewModel {
	var query: ReplaySubject<String> { get }
}
