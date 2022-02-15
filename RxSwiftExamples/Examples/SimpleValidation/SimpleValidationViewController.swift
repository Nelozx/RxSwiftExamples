//
//  SimpleValidationViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/15.
//

import RxSwift

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: ViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLB: UILabel!
    @IBOutlet weak var doSomethingBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLB.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordLB.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        // 如果没有这个映射，每个绑定只会执行一次，默认情况下rx是无状态的
        let usernameValid = usernameTF.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid)
        { $0 && $1 }
        .share(replay: 1)
        
        usernameValid
            .bind(to: usernameLB.rx.isHidden)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: passwordTF.rx.isEnabled)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordLB.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
