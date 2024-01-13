import SwiftUI

struct LoginView<Model>: View where Model:LoginViewModelInterface {
    @StateObject private var viewModel: Model
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $viewModel.loginModel.email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $viewModel.loginModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $viewModel.presentAlert, content: {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                })
                Spacer()
                
                NavigationLink("Not registered yet? create account",
                               destination: presenter!.getRegistration() )
                
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
