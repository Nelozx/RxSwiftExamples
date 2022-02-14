//
//  ViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/14.
//

import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class ViewController: OSViewController {
    var disposeBag = DisposeBag()
}
