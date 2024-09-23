//
//  StylesheetRenderer.swift
//  SwiftCss
//
//  Created by Tibor Bodecs on 2021. 11. 21..
//

public struct StylesheetRenderer {
    
    private let newline: String
    private let singleSpace: String
    public let minify: Bool
    public let indent: Int
    
    public init(minify: Bool = false, indent: Int = 4) {
        self.minify = minify
        self.indent = minify ? 0 : indent
        self.newline = minify ? "" : "\n"
        self.singleSpace = minify ? "" : " "
    }
    
    public func render(_ stylesheet: Stylesheet) -> String {
        stylesheet.children.map { child in
            switch child {
            case let selector as Selector:
                return renderSelector(selector)
            case let charset as Charset:
                return #"@charset ""# + charset.name + #"";"#
            case let value as FontFace:
                let properties = value.properties.map { renderProperty($0) }.joined(separator: newline)
                return "@font-face {" + newline + properties + newline + "}"
            case let value as Import:
                return "@import " + value.name + ";"
            case let keyframes as Keyframes:
                let selectors = keyframes.selectors.map { renderSelector($0) }.joined(separator: newline)
                return "@keyframes " + keyframes.name + singleSpace + "{" + newline + selectors + newline + "}" + newline
            case let media as Media:
                let level = media.query != nil ? 1 : 0
                var selectors = media.selectors.map { renderSelector($0, level: level) }.joined(separator: newline)
                if let query = media.query {
                    selectors = "@media " + query + singleSpace + "{" + newline + selectors + newline + "}"
                }
                return selectors
            default:
                fatalError("unknown rule object")
            }
        }.joined(separator: newline)
    }
    
    // MARK: - helpers
    
    private func renderProperty(_ property: Property, level: Int = 0) -> String {
        let spaces = String(repeating: " ", count: level * indent)
        return spaces + property.name + ":" + singleSpace + property.value + (property.isImportant ? " !important" : "")
    }
    
    private func renderSelector(_ selector: Selector, level: Int = 0, parentSelector: String? = nil) -> String {
        let spaces = String(repeating: " ", count: level * indent)
        var suffix = ""
        if let pseudo = selector.pseudo {
            suffix = pseudo
        }
        
        var output = ""
        let fullSelectorName: String
        if let parentSelector {
            fullSelectorName = parentSelector + " " + selector.name
        } else {
            fullSelectorName = selector.name
        }
        
        let properties = selector.children.compactMap { $0 as? Property }
        if properties.count > 0 {
            let renderedProperties = properties.map { renderProperty($0, level: level + 1) }.joined(separator: ";" + newline) + (!minify ? ";" : "")
            output += spaces + fullSelectorName + suffix + singleSpace + "{" + newline + renderedProperties + newline + spaces + "}"
        }
        
        let nestedSelectors = selector.children.compactMap { $0 as? Selector }
        if nestedSelectors.count > 0 {
            output += newline
            output += nestedSelectors.map { renderSelector($0, level: level, parentSelector: fullSelectorName) }.joined(separator: newline)
        }

        return output
    }
}
