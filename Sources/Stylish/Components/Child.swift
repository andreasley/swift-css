import Foundation

public struct Child: SelectorChild  {
    
    var selectors: [Selector]

    public init(selectors: [Selector]) {
        self.selectors = selectors
    }

    public init(@ChildBuilder<Selector> _ builder: () -> [Selector]) {
        self.selectors = builder()
    }
}

extension Child {
    public func render(configuration: RenderConfiguration, level: Int = 0, parentSelector: String? = nil) -> String {
        var output = ""
        guard let parentSelector else { return "" }
        let fullSelectorName = parentSelector + " >"
        let renderedSelectors = selectors.map { $0.render(configuration: configuration, level: level, parentSelector: fullSelectorName) }.joined(separator: configuration.newline)
        output += renderedSelectors
        return output
    }
}
