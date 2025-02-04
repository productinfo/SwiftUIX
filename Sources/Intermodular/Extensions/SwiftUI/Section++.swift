//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

fileprivate struct _SwiftUI_Section<Parent, Content, Footer> {
    let header: Parent
    let content: Content
    let footer: Footer
}

extension Section {
    fileprivate var _internalStructure: _SwiftUI_Section<Parent, Content, Footer> {
        if MemoryLayout<Self>.size == MemoryLayout<(Parent, Content, Footer)>.size {
            let guts = unsafeBitCast(self, to: (Parent, Content, Footer).self)
            
            return .init(header: guts.0, content: guts.1, footer: guts.2)
        } else {
            let mirror = Mirror(reflecting: self)
            
            let header = mirror[_SwiftUIX_keyPath: "header"] as! Parent
            let content = mirror[_SwiftUIX_keyPath: "content"] as! Content
            let footer = mirror[_SwiftUIX_keyPath: "footer"] as! Footer
            
            return .init(header: header, content: content, footer: footer)
        }
    }
    
    public var header: Parent {
        _internalStructure.header
    }
    
    public var content: Content {
        _internalStructure.content
    }
    
    public var footer: Footer {
        _internalStructure.footer
    }
}

extension Section where Parent == Text, Content: View, Footer == EmptyView {
    @_disfavoredOverload
    public init(_ header: Text, @ViewBuilder content: () -> Content) {
        self.init(header: header, content: content)
    }

    @_disfavoredOverload
    public init<S: StringProtocol>(_ header: S, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
    
    @_disfavoredOverload
    public init(_ header: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
    
    @_disfavoredOverload
    public init<S: StringProtocol>(header: S, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
}

extension Section where Parent == Text, Content: View, Footer == Text {
    public init<S: StringProtocol>(
        header: S,
        footer: S,
        @ViewBuilder content: () -> Content
    ) {
        self.init(header: Text(header), footer: Text(footer), content: content)
    }
}
