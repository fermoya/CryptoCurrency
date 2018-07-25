//
//  Estension.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/21/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import Charts
import RxCocoa

class RxChartViewDelegateProxy: DelegateProxy<ChartViewBase, ChartViewDelegate>, DelegateProxyType, ChartViewDelegate {
	
	init(chartView: ChartViewBase) {
		super.init(parentObject: chartView, delegateProxy: RxChartViewDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		register(make: self.init)
	}
	
	static func currentDelegate(for object: ChartViewBase) -> ChartViewDelegate? {
		return object.delegate
	}
	
	static func setCurrentDelegate(_ delegate: ChartViewDelegate?, to object: ChartViewBase) {
		object.delegate = delegate
	}
	
}

extension Reactive where Base: ChartViewBase {
	
	public var data: Binder<LineChartData> {
		return Binder<LineChartData>(self.base) { chartView, lineChartData in
			chartView.data = lineChartData
		}
	}
	
	public var delegate: DelegateProxy<ChartViewBase, ChartViewDelegate> {
		return RxChartViewDelegateProxy.proxy(for: base)
	}
	
	public var entrySelected: Observable<ChartDataEntry> {
		return delegate.methodInvoked(#selector(ChartViewDelegate.chartValueSelected(_:entry:highlight:))).map { paramters in
			return paramters[1] as! ChartDataEntry
		}
	}
	
}
