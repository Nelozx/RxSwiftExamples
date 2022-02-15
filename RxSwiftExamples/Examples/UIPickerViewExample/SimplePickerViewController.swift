//
//  ExamplePickerViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/11.
//

import RxSwift

class SimplePickerViewController: ViewController {
    @IBOutlet weak var pickerView1: UIPickerView!
    
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Observable.just([1, 2, 3, 4, 5])
            .bind(to: pickerView1.rx.itemTitles) { "\($1)" }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: {
                print("models selected 1: \($0)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) {
                NSAttributedString(string: "\($1)",
                    attributes: [
                        .foregroundColor: UIColor.systemPink,
                        .underlineStyle: NSUnderlineStyle.double.rawValue
                    ])
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: {
                print("models selected 2: \($0)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.systemRed,
                         UIColor.green,
                         UIColor.magenta,
                         UIColor.systemBrown])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: {
                print("models selected 3: \($0)")
            })
            .disposed(by: disposeBag)
    }
}
