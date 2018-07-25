//
//  CurrencyConverterViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import RxGesture
import ChameleonFramework
import RxAnimated
import CryptoCurrencyData

class CurrencyConverterViewController: UIViewController {

	@IBOutlet weak var fromSymbolLabel: UILabel!
	@IBOutlet weak var fromSymbolContainerView: UIView!
	@IBOutlet weak var fromSymbolsSetPickerView: UIPickerView!
	@IBOutlet weak var heightFromSymbolSetPickerViewConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var toSymbolLabel: UILabel!
	@IBOutlet weak var toSymbolContainerView: UIView!
	@IBOutlet weak var toSymbolsSetPickerView: UIPickerView!
	@IBOutlet weak var heighToSymbolSetPickerViewConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var exchangeIconImageView: UIImageView!
	@IBOutlet weak var conversionLabel: UILabel!
	
	private var heightBasePickerView = BehaviorRelay<CGFloat>(value: 0)
	private var heightFromPickerView = BehaviorRelay<CGFloat>(value: 0)
	private var baseCurrency = BehaviorRelay<String>(value: "")
	private var fromSymbolCurrency = BehaviorRelay<String>(value: "")
	
	var viewModel: CurrencyConverterViewModel
	
	init(viewModel: CurrencyConverterViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
		
		let tabBarItem = UITabBarItem()
		tabBarItem.image = UIImage(named: "icon-tab-currency-exchange", in: Bundle(for: type(of: self)), compatibleWith: nil)
		tabBarItem.selectedImage = UIImage(named: "icon-tab-selected-currency-exchange", in: Bundle(for: type(of: self)), compatibleWith: nil)
		tabBarItem.tag = 2
		self.tabBarItem = tabBarItem
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
		bindViewModel()
	}

}

extension CurrencyConverterViewController: Bindable {
	typealias ViewModel = CurrencyConverterViewModel

	func setUpView() {
		let currencyExchangeIcon = UIImageView(image: UIImage(named: "icon-currency-exchange", in: Bundle(for: type(of: self)), compatibleWith: nil))
		navigationItem.titleView = currencyExchangeIcon
		
		lineChartView.dragEnabled = true
		lineChartView.setScaleEnabled(true)
		lineChartView.pinchZoomEnabled = true
		lineChartView.chartDescription?.enabled = false
		lineChartView.rightAxis.enabled = false
		lineChartView.xAxis.labelPosition = .bottom
		lineChartView.xAxis.labelRotationAngle = -45
	}
	
	func bindViewModel() {
		viewModel.coinNames
			.bind(to: fromSymbolsSetPickerView.rx.itemTitles) { return $1 }
			.disposed(by: rx.disposeBag)
		
		viewModel.coinNames
			.bind(to: toSymbolsSetPickerView.rx.itemTitles) { return $1 }
			.disposed(by: rx.disposeBag)
		
		heightBasePickerView.asObservable()
			.bind(to: heighToSymbolSetPickerViewConstraint.rx.animated.layout(duration: 0.33).constant)
			.disposed(by: rx.disposeBag)
		
		heightFromPickerView.asObservable()
			.bind(to: heightFromSymbolSetPickerViewConstraint.rx.animated.layout(duration: 0.33).constant)
			.disposed(by: rx.disposeBag)
		
		fromSymbolCurrency.asObservable()
			.bind(to: fromSymbolLabel.rx.text)
			.disposed(by: rx.disposeBag)
		
		baseCurrency.asObservable()
			.bind(to: toSymbolLabel.rx.text)
			.disposed(by: rx.disposeBag)
		
		let tapFromSymbolsSetObservable = fromSymbolContainerView.rx.tapGesture().when(.recognized)
		tapFromSymbolsSetObservable
			.map { [unowned self] _ in
				return self.heightFromSymbolSetPickerViewConstraint.constant == 150 ? 0 : 150 as CGFloat
			}.bind(to: heightFromPickerView)
			.disposed(by: rx.disposeBag)
		
		tapFromSymbolsSetObservable
			.map { _ in return 0 as CGFloat }
			.bind(to: heightBasePickerView)
			.disposed(by: rx.disposeBag)
		
		let tapToSymbolsSetObservable = toSymbolContainerView.rx.tapGesture().when(.recognized)
		tapToSymbolsSetObservable
			.map { [unowned self] _ in
				return self.heighToSymbolSetPickerViewConstraint.constant == 150 ? 0 : 150 as CGFloat
			}.bind(to: heightBasePickerView)
			.disposed(by: rx.disposeBag)
		
		tapToSymbolsSetObservable
			.map { _ in return 0 as CGFloat }
			.bind(to: heightFromPickerView)
			.disposed(by: rx.disposeBag)
		
		fromSymbolsSetPickerView.rx.itemSelected
			.map { [unowned self] row, component in
				let value: String? = try? self.fromSymbolsSetPickerView.rx.model(at: IndexPath(row: row, section: component))
				return value ?? ""
			}.map { $0 == CoinFormatter().fullName(of: Coin.None) ? "" : $0 }
			.bind(to: fromSymbolCurrency)
			.disposed(by: rx.disposeBag)
		
		toSymbolsSetPickerView.rx.itemSelected
			.map { [unowned self] row, component in
				let value: String? = try? self.toSymbolsSetPickerView.rx.model(at: IndexPath(row: row, section: component))
				return value ?? ""
			}.map { $0 == CoinFormatter().fullName(of: Coin.None) ? "" : $0 }
			.bind(to: baseCurrency)
			.disposed(by: rx.disposeBag)
		
		let pickerViewsHeightObservable = Observable.combineLatest(
			heightBasePickerView.asObservable(),
			heightFromPickerView.asObservable()
		)
		
		pickerViewsHeightObservable.filter { $0.0 == 0 && $0.1 == 0 }
			.map { [unowned self] _ in return self.exchangeIconImageView.image }
			.bind(animated: exchangeIconImageView.rx.animated.fadeIn(duration: 0.33).image)
			.disposed(by: rx.disposeBag)
		
		pickerViewsHeightObservable.filter { $0.0 != 0 || $0.1 != 0 }
			.map { [unowned self] _ in return self.exchangeIconImageView.image }
			.bind(animated: exchangeIconImageView.rx.animated.fadeOut(duration: 0.33).image)
			.disposed(by: rx.disposeBag)
		
		// Pintar gráfica
		let currenciesObservable = Observable.combineLatest(fromSymbolCurrency.asObservable(), baseCurrency.asObservable())
		let conversionInfoObservable = Observable.combineLatest(pickerViewsHeightObservable, currenciesObservable)
			.filter { combination -> Bool in
				let heights = combination.0
				let texts = combination.1
				return !texts.0.isEmpty && !texts.1.isEmpty && heights.0 == 0 && heights.1 == 0
			}
		
		conversionInfoObservable.flatMapLatest { [unowned self] combination -> Observable<[ChartDataEntry]> in
				let texts = combination.1
				return self.viewModel.chart(for: texts.0, with: texts.1)
			}.map { [unowned self] entries in LineChartDataSet(values: entries, label: "\(self.fromSymbolCurrency.value)-\(self.baseCurrency.value)") }
			.do(onNext: configureDataSet)
			.do(onNext: { [unowned self] _ in
				self.fromSymbolCurrency.accept("")
				self.baseCurrency.accept("")
				self.fromSymbolsSetPickerView.selectRow(0, inComponent: 0, animated: false)
				self.toSymbolsSetPickerView.selectRow(0, inComponent: 0, animated: false)
			})
			.map(LineChartData.init)
			.bind(to: lineChartView.rx.data)
			.disposed(by: rx.disposeBag)
		
		let graphInfoIsHidden = conversionInfoObservable.map { _ in return false }.startWith(true)
		graphInfoIsHidden.bind(to: conversionLabel.rx.isHidden)
			.disposed(by: rx.disposeBag)
		
		graphInfoIsHidden.bind(to: lineChartView.rx.isHidden)
			.disposed(by: rx.disposeBag)
		
		conversionInfoObservable.map { combination -> String in
				let texts = combination.1
				let coinFormatter = CoinFormatter()
				let fromCurrency = coinFormatter.shortName(from: texts.0)
				let baseCurrency = coinFormatter.shortName(from: texts.1)
				return "\(fromCurrency) - \(baseCurrency)"
			}.bind(to: conversionLabel.rx.text)
			.disposed(by: rx.disposeBag)
	}
	
	private func configureDataSet(_ dataSet: LineChartDataSet) {
		//		set1.drawIconsEnabled = false
		//
		//		set1.lineDashLengths = [5, 2.5]
		//		set1.highlightLineDashLengths = [5, 2.5]
		
		let chartColor: UIColor = .red
		dataSet.setColor(chartColor)
		dataSet.setCircleColor(chartColor.darken(byPercentage: 0.3))
		
		dataSet.lineWidth = 3
		dataSet.circleRadius = 5
		dataSet.drawCircleHoleEnabled = false
		//		set1.valueFont = .systemFont(ofSize: 9)
		//		set1.formLineDashLengths = [5, 2.5]
		//		set1.formLineWidth = 1
		//		set1.formSize = 15
		//
		//		let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
		//							  ChartColorTemplates.colorFromString("#ffff0000").cgColor]
		//		let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
		//
		//		set1.fillAlpha = 1
		//		set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
		//		set1.drawFilledEnabled = true
	}
	
}
