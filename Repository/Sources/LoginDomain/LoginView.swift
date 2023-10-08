//
//  LoginView.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import SwiftUI
import SwiftUDF

public struct LoginView: View {
    private struct Drawing {
        static let contentSpacing: CGFloat = 10
    }
    
    let registerButtonTap: () -> Void
    @StateObject var store: StoreOf<LoginDomain>
    
    public var body: some View {
        VStack(spacing: Drawing.contentSpacing) {
            Spacer()
            CredentialTextField(
                label: Localized.emailTextFieldLabel,
                placeholder: Localized.emailPlaceholder,
                text: bindEmail(), 
                isValid: store.isEmailValid
            )
            .textContentType(.emailAddress)
            CredentialTextField(
                label: Localized.passwordTextFieldLabel,
                placeholder: Localized.passwordPlaceholder,
                text: bindPassword(),
                isSecure: true, 
                isValid: store.isPasswordValid
            )
            .textContentType(.password)
            BigBlueButton(
                title: Localized.loginButtonTitle,
                action: { store.send(.loginButtonTap) }
            )
            .disabled(!store.isLoginButtonActive)
            Spacer()
            HStack {
                Text(Localized.registrationLink)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                Button(action: registerButtonTap) {
                    Text(Localized.registrationButtonTitle)
                        .font(.caption)
                        .foregroundStyle(Color.green)
                }
            }
        }
        .padding()
        .alert(
            "",
            isPresented: bindAlert()
        ) {
            Button(role: .cancel, action: {}) {
                Text("Cancel")
            }
        } message: {
            Text(store.alertText)
        }

    }
    
    //MARK: - init(_:)
    public init(
        store: StoreOf<LoginDomain> = LoginDomain.liveStore,
        registerButtonTap: @escaping () -> Void
    ) {
        self._store = .init(wrappedValue: store)
        self.registerButtonTap = registerButtonTap
    }
    
    //MARK: - Private methods
    private func bindEmail() -> Binding<String> {
        .init(
            get: { store.email },
            set: { store.send(.setEmail($0)) }
        )
    }
    
    private func bindPassword() -> Binding<String> {
        .init(
            get: { store.password },
            set: { store.send(.setPassword($0)) }
        )
    }
    
    private func bindAlert() -> Binding<Bool> {
        .init(
            get: { store.isAlert },
            set: { _ in }
        )
    }
    
}

#Preview("Default") {
    LoginView(store: LoginDomain.previewStore, registerButtonTap: {})
}

#Preview("Error") {
    LoginView(store: LoginDomain.alertStore, registerButtonTap: {})
}
