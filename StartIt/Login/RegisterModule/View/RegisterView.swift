import SwiftUI


struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var secondName: String = ""
    @State private var isu: String = ""
    @State private var alertIsPresented = false
    @State private var alertMessage = ""
    
    var presenter : RegisterViewToPresenterProtocol?
    
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
                
                TextField("First name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                TextField("Second name", text: $secondName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                TextField("ISU number", text: $isu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                Button(action: {
                    presenter?.register(user: User(
                        id: 100, name: firstName, familyName: secondName,
                        isuNumber: Int(isu) ?? 0, username: username, password: password))
                }) {
                    Text("Register")
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
            }
            .padding()
        }
    }
}

extension RegisterView: RegisterPresenterToViewProtocol {
    func error(message: String) {
        alertMessage = message
        alertIsPresented.toggle()
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
