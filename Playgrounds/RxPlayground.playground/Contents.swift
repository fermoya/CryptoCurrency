//: A UIKit based Playground for presenting user interface

import UIKit
import RxSwift
import PlaygroundSupport

let diposeBag = DiposeBag()
Observable<Int>.timer(1, scheduler: MainScheduler.instance).debug("timer", trimOutput: true).suscribe().disposed(by: diposeBag)

PlaygroundPage.current.needsIndefiniteExecution = true
