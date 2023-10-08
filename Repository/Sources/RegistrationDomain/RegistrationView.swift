//
//  RegistrationView.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import SwiftUI
import SwiftUDF

public struct RegistrationView: View {
    @StateObject private var store: StoreOf<RegistrationDomain>
    private let loginButtonTap: () -> Void
    
    public var body: some View {
        VStack {
            CredentialTextField(
                label: "First name",
                placeholder: "Enter your first name",
                text: bindFirstName()
            )
        }
        .padding()
    }
    
    //MARK: - init(_:)
    public init(
        store: StoreOf<RegistrationDomain> = RegistrationDomain.liveStore,
        loginButtonTap: @escaping () -> Void
    ) {
        self._store = .init(wrappedValue: store)
        self.loginButtonTap = loginButtonTap
    }
    
    //MARK: - Private methods
    private func bindFirstName() -> Binding<String> {
        .init(
            get: { store.firstName },
            set: { store.send(.setFirstName($0)) }
        )
    }
}

#Preview {
    RegistrationView(
        store: RegistrationDomain.previewStore,
        loginButtonTap: {}
    )
}
