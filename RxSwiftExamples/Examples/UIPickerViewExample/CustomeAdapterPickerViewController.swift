//
//  CustomAdapterPickerViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/14.
//

import RxSwift
import RxCocoa

class CustomeAdapterPickerViewController: ViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        Observable.just([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
            //  adapter: 用于将元素转换为选择器组件的适配器。
            .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
}

final class PickerViewViewAdapter: NSObject, UIPickerViewDelegate,
                                   UIPickerViewDataSource,
                                   RxPickerViewDataSourceType,
                                   SectionedViewDataSourceType {
    
    
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []
    
    func model(at indexPath: IndexPath) throws -> Any {
        items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items[component].count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
