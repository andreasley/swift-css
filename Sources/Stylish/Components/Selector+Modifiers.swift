//
//  Selector+Modifiers.swift
//  SwiftCss
//
//  Created by Tibor Bodecs on 2021. 07. 10..
//

public extension Selector {

    func pseudo(_ pseudo: PseudoClass) -> Selector {
        Selector(name: name, children: children, pseudo: pseudo.value)
    }
}
