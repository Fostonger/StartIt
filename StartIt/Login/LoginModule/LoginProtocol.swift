import SwiftUI

protocol LoginViewToPresenterProtocol {
    var view: LoginPresenterToViewProtocol? { get set }
    var interactor: LoginPresenterToInteractorProtocol? { get set }
    var router: LoginPresenterToRouterProtocol? { get set }
    
    func login(username: String, password: String)
    func getRegistration() -> RegisterView?
}

protocol LoginPresenterToViewProtocol {
    mutating func error(message : String)
}

protocol LoginPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: LoginInteractorToPresenter? { get set }
    
    func login(username: String, password: String)
}

protocol LoginInteractorToPresenter {
    func success(user: User)
    func fail(errorMessage: String)
}

protocol LoginPresenterToRouterProtocol {
    static func createModule(loginHandler: @escaping (User) -> ()) -> LoginView
    func successfulLogin(user: User)
    func getRegistration() -> RegisterView
}
