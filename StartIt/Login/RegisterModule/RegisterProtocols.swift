protocol RegisterViewToPresenterProtocol {
    var view: RegisterPresenterToViewProtocol? {get set}
    var interactor: RegisterPresenterToInteractorProtocol? {get set}
    var router: RegisterPresenterToRouterProtocol? {get set}
    
    func register(user: User)
    
}

protocol RegisterPresenterToViewProtocol {
    func error(message : String)
}

protocol RegisterPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: RegisterInteractorToPresenter? { get set }
    
    func register(user: User)
}

protocol RegisterInteractorToPresenter {
    func success(user: User)
    func fail(errorMessage: String)
}


protocol RegisterPresenterToRouterProtocol {
    static func createModule(loginHandler: @escaping (User) -> ()) -> RegisterView
    func successfulRegistration(user: User)
}
