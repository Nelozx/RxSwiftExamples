//
//  RootViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/11.
//

import UIKit

struct Section {
    var header: String = ""
    var footer: String = ""
    var rows: [Row] = []
}

struct Row {
    var title: String
    var desc: String
    var target: UIViewController.Type = UIViewController.self
}

class RootViewController: UITableViewController {
    
    let dataSource = [
        Section(footer: "展示Rx的例子。在弹出导航堆栈期间，您可以轻松测试适当的资源清理"),
        Section(header: "iPhone Examples", rows: [
            Row(title: "Adding numbers", desc: "Bindings", target: NumbersViewController.self),
            Row(title: "Simple validation", desc: "Bindings", target: SimpleValidationViewController.self),
            Row(title: "Geolocation Subscription", desc: "Observers, service and Drive example", target: GeolocationViewController.self),
            Row(title: "GitHub Signup - Vanilla Observables", desc: "Simple MVVM example", target: GitHubSignupViewController.self),
            Row(title: "GitHub Signup - Using Driver", desc: "Simple MVVM example "),
            Row(title: "API wrappers", desc: "API wrappers Example"),
            Row(title: "Calculator", desc: "Stateless calculator example"),
            Row(title: "ImagePicker", desc: "UIImagePickerController example"),
            Row(title: "UIPickerView", desc: "UIPickerView example", target: PickerViewTabBarController.self)
        ]),
        Section(header: "Table/Collection view examples", rows: [
            Row(title: "Simplest table view example", desc: "Basic"),
            Row(title: "Simplest table view example with sections", desc: "Basic"),
            Row(title: "TableView with editing", desc: "Model editing using observable sequences, master/detail"),
            Row(title: "Table/CollectionView partial updates", desc: "Table and Collection view with partial updates"),
        ]),
        Section(header: "Complex examples", rows: [
            Row(title: "Search Wikipedia", desc: "Complex async, activity indicator"),
            Row(title: "GitHub Search Repositories", desc: "Paging, activity indicator"),
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        title = "Rx Examples"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL")
        
        let model = dataSource[indexPath.section].rows[indexPath.row]
        cell.detailTextLabel?.text = model.desc
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.section].rows[indexPath.row]
        let vc = model.target.init()
        vc.title = model.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataSource[section].header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String {
        dataSource[section].footer
    }
    
}

