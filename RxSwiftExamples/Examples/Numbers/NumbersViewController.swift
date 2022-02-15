//
//  NumbersViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/11.
//

import RxSwift
import RxCocoa


class NumbersViewController: ViewController {
    
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    
    @IBOutlet weak var result: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observable: 可监听序列
        // combineLatest: 将指定的可观察序列合并为一个可观察序列
        Observable.combineLatest(TF1.rx.text.orEmpty, TF2.rx.text.orEmpty, TF3.rx.text.orEmpty) {
            (Int($0) ?? 0) + (Int($1) ?? 0) + (Int($2) ?? 0)
        }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)
    }
}
