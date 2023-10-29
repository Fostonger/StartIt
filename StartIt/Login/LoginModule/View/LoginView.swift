import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alertIsPresented = false
    @State private var alertMessage = ""
    
    var presenter: LoginViewToPresenterProtocol?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                Button(action: {
                    presenter?.login(username: username, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $alertIsPresented, content: {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
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

extension LoginView: LoginPresenterToViewProtocol {
     func error(message: String) {
        alertMessage = message
        alertIsPresented = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
