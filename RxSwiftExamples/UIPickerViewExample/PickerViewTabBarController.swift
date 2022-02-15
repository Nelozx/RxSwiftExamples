//
//  SimplePickerViewTabBarController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/14.
//

import UIKit

class PickerViewTabBarController: UITabBarController {
    
    lazy var simplePickerViewController: SimplePickerViewController = {
        let vc = SimplePickerViewController()
        vc.tabBarItem.title = "Convenience extensions"
        vc.tabBarItem.image = UIImage(systemName: "folder.circle.fill")
        return vc
    }()
    lazy var customAdapterPickerViewController: CustomeAdapterPickerViewController = {
        let vc = CustomeAdapterPickerViewController()
        vc.tabBarItem.title = "Custom Adapters"
        vc.tabBarItem.image = UIImage(systemName: "paperplane.circle.fill")
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [simplePickerViewController, customAdapterPickerViewController]
    }

}
