import SwiftUI


struct RegisterView<Model>: View where Model:RegisterViewModelInterface {
    @StateObject var viewModel: Model
    @State private var alertIsPresented = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $viewModel.registerModel.username ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.registerModel.password ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                TextField("First name", text: $viewModel.registerModel.firstName ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                TextField("Second name", text: $viewModel.registerModel.secondName ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                TextField("ISU number", text: $viewModel.registerModel.isu ?! "")
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                MIButton(title: "Register", disabled: $viewModel.registerButtonDisabled) {
                    viewModel.register()
                }
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $viewModel.presentAlert, content: {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        })
    }
}

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: MockRegisterViewModel.registerViewModel)
    }
}
