//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AlertPresentationLink<Label: View, Actions: View, Message: View>: View {
    private let title: Text
    private let label: Label
    private let actions: Actions
    private let message: Message
    
    private var onConfirm: (() -> Void)?
    
    @State private var isPresented: Bool = false
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label
        }
        .alert(
            title,
            isPresented: $isPresented,
            actions: {
                actions
                
                if let onConfirm {
                    Button("Cancel", role: .cancel) {
                        isPresented = false
                    }
                    
                    Button("Confirm") {
                        onConfirm()
                    }
                }
            },
            message: {
                message
            }
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AlertPresentationLink {
    public init(
        _ title: String,
        @ViewBuilder label: () -> Label,
        @ViewBuilder actions: () -> Actions,
        @ViewBuilder message: () -> Message
    ) {
        self.title = Text(title)
        self.label = label()
        self.actions = actions()
        self.message = message()
    }
    
    public init(
        _ title: String,
        @ViewBuilder label: () -> Label,
        @ViewBuilder actions: () -> Actions
    ) where Message == EmptyView {
        self.title = Text(title)
        self.label = label()
        self.actions = actions()
        self.message = EmptyView()
    }
    
    public init(
        _ title: String,
        @ViewBuilder label: () -> Label,
        @ViewBuilder content: () -> Actions,
        onConfirm: (() -> Void)? = nil
    ) where Message == EmptyView {
        self.title = Text(title)
        self.label = label()
        self.actions = content()
        self.message = EmptyView()
        self.onConfirm = onConfirm
    }
}
