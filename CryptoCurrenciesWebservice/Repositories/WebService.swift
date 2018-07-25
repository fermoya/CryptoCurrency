//
//  WebService.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/14/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Reachability

public enum WebServiceError: Error {
	case unknown(String)
	case unauthorized
	case notFound
	case badRequest
	case forbidden
	case unavailable
	case badGateway
	case internalServerError
	case requestFailed(Int)
}

public class WebService {

	public func fetch<T: Decodable>(type: T.Type, from url: String) -> Observable<T> {
		return RxAlamofire.requestData(.get, url).flatMapLatest { response , data -> Observable<T> in
			return Observable.create { [weak self] suscriber in
				guard 200..<300 ~= response.statusCode else {
					let error = self?.processHttpError(code: response.statusCode) ?? .unknown("Failed to retrieve content from \(url)")
					suscriber.onError(error)
					return Disposables.create()
				}
				
				do {
					let result = try JSONDecoder().decode(type, from: data)
					suscriber.onNext(result)
				} catch {
					suscriber.onError(WebServiceError.unknown("Failed to decode response"))
				}
				
				return Disposables.create()
			}
			
		}.retryWhen { _ in return InternetService.shared.isReachableObservable }
		
	}
	
	private func processHttpError(code: Int) -> WebServiceError {
		switch code {
		case 400:
			return .badRequest
		case 401:
			return .unauthorized
		case 403:
			return .forbidden
		case 404:
			return .notFound
		case 500:
			return .internalServerError
		case 502:
			return .badGateway
		case 503:
			return .unavailable
		default:
			return .requestFailed(code)
		}
	}
	
}

fileprivate class InternetService {
	
	private let reachability: Reachability
	private let isReachableObserver = ReplaySubject<Bool>.create(bufferSize: 1)
	
	static var shared = InternetService()
	var isReachableObservable: Observable<Bool> {
		return isReachableObserver.asObservable()
	}
	
	private init() {
		self.reachability = Reachability()
		
		let connectionChanged: (Reachability?) -> Void = { [weak self] reachability in
			self?.isReachableObserver.onNext(reachability?.isReachable() ?? false)
		}
		
		self.reachability.reachableBlock = connectionChanged
		self.reachability.unreachableBlock = connectionChanged
		self.reachability.startNotifier()
	}
	
}
