//
//  Animated+Crypto.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/29/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxAnimated

extension AnimatedSink where Base: UIView {
	public func fadeOut(duration: TimeInterval) -> AnimatedSink<Base> {
		let type = AnimationType<Base>(type: RxAnimationType.transition(.curveEaseIn), duration: duration, animations: { view in
			view.alpha = 0
		})
		return AnimatedSink<Base>(base: self.base, type: type)
	}
	
	public func fadeIn(duration: TimeInterval) -> AnimatedSink<Base> {
		let type = AnimationType<Base>(type: RxAnimationType.transition(.curveEaseIn), duration: duration, animations: { view in
			view.alpha = 1
		})
		return AnimatedSink<Base>(base: self.base, type: type)
	}
}
