import SwiftUI

struct LoginView<Model>: View where Model:LoginViewModelInterface {
    @StateObject var viewModel: Model
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $viewModel.loginModel.email ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.loginModel.password ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                MIButton(title: "Login", disabled: $viewModel.loginButtonDisabled) {
                    viewModel.login()
                }
                Spacer()
                
                NavigationLink {
                    LoginRouter.makeRegistrationView(with: viewModel.createRegisterViewModel())
                } label: {
                    Text("Not registered yet? create account")
                }
                
            }
            .padding()
        }
        .alert(isPresented: $viewModel.presentAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: MockLoginViewModel.loginViewModel)
    }
}
