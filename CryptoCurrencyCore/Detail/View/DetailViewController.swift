//
//  DetailViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/20/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CryptoCurrencyData
import NSObject_Rx
import ChameleonFramework
import Charts

class DetailViewController: UIViewController, Bindable {

	@IBOutlet weak var coinIconImageView: UIImageView!
	@IBOutlet weak var coinNameLabel: UILabel!
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var chartSegmentedControl: UISegmentedControl!
	@IBOutlet weak var timePeriodSegmentedControl: UISegmentedControl!
	@IBOutlet weak var detailView: UIView!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var datePriceLabe: UILabel!
	
	private(set) var viewModel: DetailViewModel
	private var isImageDownloaded = BehaviorRelay<Bool>(value: false)
	
	init(viewModel: DetailViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
		bindViewModel()
	}

	func setUpView() {
		lineChartView.dragEnabled = true
		lineChartView.setScaleEnabled(true)
		lineChartView.pinchZoomEnabled = true
		lineChartView.chartDescription?.enabled = false
		lineChartView.rightAxis.enabled = false
		lineChartView.xAxis.labelPosition = .bottom
		lineChartView.xAxis.labelRotationAngle = -45
	}
	
	func bindViewModel() {
		viewModel.virtualGood.asObservable()
			.map { $0.fullName }
			.bind(to: coinNameLabel.rx.text)
			.disposed(by: rx.disposeBag)
		
		viewModel.virtualGood.asObservable()
			.map { $0.imageUrlString }
			.filter { $0 != nil }
			.map { URL(string: $0!) }
			.filter { $0 != nil }
			.do(onNext: { [unowned self] url in
				self.coinIconImageView.kf.setImage(with: url, completionHandler: { [weak self] _, _, _, _ in self?.isImageDownloaded.accept(true) })
			})
			.subscribe().disposed(by: rx.disposeBag)
		
		viewModel.periodFormatted.bind(to: rx.title).disposed(by: rx.disposeBag)
		
		chartSegmentedControl.rx.selectedSegmentIndex
			.map { ChartType(rawValue: $0)! }
			.bind(to: viewModel.chartType)
			.disposed(by: rx.disposeBag)
		
		Observable.combineLatest(viewModel.chartType.asObservable(), viewModel.chartEntries)
			.map { type, entries in LineChartDataSet(values: entries, label: type.description) }
			.do(onNext: configureDataSet).map(LineChartData.init)
			.bind(to: lineChartView.rx.data)
			.disposed(by: rx.disposeBag)
		
		viewModel.chartEntries
			.map { _ in return false }
			.startWith(true)
			.bind(to: lineChartView.rx.isHidden)
			.disposed(by: rx.disposeBag)
		
		timePeriodSegmentedControl.rx.selectedSegmentIndex
			.map { RecordPeriod(rawValue: $0)! }
			.bind(to: viewModel.recordPeriod)
			.disposed(by: rx.disposeBag)
		
		let entrySelectedObservable = lineChartView.rx.entrySelected
		Observable.combineLatest(entrySelectedObservable, viewModel.currency.asObservable())
			.map { "\($0.y) \($1.rawValue)" }
			.bind(to: priceLabel.rx.text)
			.disposed(by: rx.disposeBag)
		
		entrySelectedObservable
			.map { entry in
				let date = Date(timeIntervalSince1970: entry.x)
				let calendar = Calendar(identifier: .gregorian)
				let components = calendar.dateComponents([.day, .month, .year], from: date)
				return "\(components.day!)/\(components.month!)/\(components.year!)"
			}.bind(to: datePriceLabe.rx.text)
			.disposed(by: rx.disposeBag)
		
		entrySelectedObservable
			.map { _ in return false }
			.startWith(true)
			.bind(to: detailView.rx.isHidden)
			.disposed(by: rx.disposeBag)
	}
	
	private func configureDataSet(_ dataSet: LineChartDataSet) {
//		set1.drawIconsEnabled = false
//
//		set1.lineDashLengths = [5, 2.5]
//		set1.highlightLineDashLengths = [5, 2.5]

		isImageDownloaded.asObservable().filter { $0 }.do(onNext: { [unowned self] _ in
			let imageAverageColor = UIColor(averageColorFrom: self.coinIconImageView.image) ?? .black
			dataSet.setColor(imageAverageColor)
			dataSet.setCircleColor(imageAverageColor.darken(byPercentage: 0.3))
		}).subscribe().disposed(by: rx.disposeBag)
		
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
