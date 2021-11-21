# SwiftCss

An awesome Swift CSS DSL library using result builders.

```swift
let css = Stylesheet {            
    Media {
        All {
            Background("#222")
        }
        Root {
            Color(.blue)
        }
        Element(.div) {
            BackgroundColor(.red)
            Color(.white)
            TextAlign("left")
        }
        .pseudo(.nthChild(2))
    }
    Media("only screen and (max-width: 600px)") {
        Id("custom-identifier") {
            Background("#222")
            Color(.cyan)
        }
        Class("custom-class") {
            Background("#333")
            Color(.aliceBlue)
        }
        Selector("ul > li > a") {
            Background("black")
            Color(.red)
                .important()
        }
        .pseudo(.hover)
    }
}
    
print(StylesheetRenderer().render(css))
```

## Credits & references

- [Cascading Style Sheets](https://www.w3.org/Style/CSS/)
- [CSS Snapshot 2020](https://www.w3.org/TR/css-2020/) 
- [CSS Working Group Editor Drafts](https://drafts.csswg.org/)
- [W3Schools CSS reference](https://www.w3schools.com/cssref/)
- [CSS: Cascading Style Sheets](https://developer.mozilla.org/en-US/docs/Web/CSS)
- [CSS3](https://www.quackit.com/css/css3/)
