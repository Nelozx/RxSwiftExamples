//
//  GitHubSignupViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/16.
//

import RxSwift

class GitHubSignupViewController: ViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameDesLbl: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordDescLbl: UILabel!
    
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var repeatedPasswordDescLbl: UILabel!
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GithubSignupViewModel(
            input: (
                username: usernameTF.rx.text.orEmpty.asObservable(),
                password: passwordTF.rx.text.orEmpty.asObservable(),
                repeatedPassword: rePasswordTF.rx.text.orEmpty.asObservable(),
                loginTaps: signupBtn.rx.tap.asObservable()
            ),
            dependency: (
                API: GitHubDefaultAPI.shared,
                validationService: GitHubDefaultValidationService.shared,
                wireframe: DefaultWireframe.shared
            )
        )
        
        // bind results to  {
        viewModel.signupEnabled
            .subscribe(onNext: { [weak self] valid  in
                self?.signupBtn.isEnabled = valid
                self?.signupBtn.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

        viewModel.validatedUsername
            .bind(to: usernameDesLbl.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.validatedPassword
            .bind(to: passwordDescLbl.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.validatedPasswordRepeated
            .bind(to: repeatedPasswordDescLbl.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.signingIn
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.signedIn
            .subscribe(onNext: { print("User signed in \($0)") })
            .disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)

    }
}
