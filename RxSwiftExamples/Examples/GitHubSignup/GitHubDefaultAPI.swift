//
//  GitHubDefaultAPI.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/23.
//

import RxSwift

class GitHubDefaultValidationService: GitHubValidationService {
    let API: GitHubAPI

    static let shared = GitHubDefaultValidationService(API: GitHubDefaultAPI.shared)

    let minPasswordCount = 5
    init (API: GitHubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        // 用户名只能包含数字
        if username.rangeOfCharacter(from: .alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }
        let loadingValue = ValidationResult.validating
        
        return API.usernameAvailable(username)
            .map {
                if $0 {
                    return .ok(message: "Username available")
                }
                return .failed(message: "Username already taken")
            }
            .startWith(loadingValue)
        
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
    
}

class GitHubDefaultAPI: GitHubAPI {
    
    let URLSession: Foundation.URLSession
    static let shared = GitHubDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    /// 验证用户名
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        // this is ofc just mock, but good enough
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.rx.response(request: request)
            .map { $0.response.statusCode == 404 }
            .catchAndReturn(false)
    }
    
    /// 注册
    func signup(_ username: String, password: String) -> Observable<Bool> {
        // mock
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }

}

extension String {
    var URLEscaped: String {
       return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
