# SwiftUI Tabs View

![Swift 5.5](https://img.shields.io/badge/swift-5.5-orange.svg)
![platform iOS 15](https://img.shields.io/badge/platform-iOS_15-blue.svg)

SwiftUI tabbed interface. Customizable replacement for `SwiftUI.TabView`.

![Example iOS app light mode](Misc/ExampleApp-iOS-light.gif#gh-light-mode-only)![Example iOS app dark mode](Misc/ExampleApp-iOS-dark.gif#gh-dark-mode-only)

- Build with vanilla `SwiftUI` (no external dependencies).
- Replaces `SwiftUI.TabView`.
- Allows wide customization.
- Supports light and dark mode.
- Tabbar hides below the keyboard, like with vanilla `SwiftUI.TabView`.

## ▶️ Usage

Add as a dependecy to your project using [Swift Package Manager](https://www.swift.org/package-manager/).

Embed in your SwiftUI view:

```swift
import SwiftUITabsView

struct ContentView: View {
  var body: some View {
    TabsView(
      tabs: /* [Tab]  */,
      selectedTab: /* Binding<Tab> */,
      ignoresKeyboard: /* Bool */,
      frameChangeAnimation: /* Animation? */,
      tabsBar: /* @ViewBuilder @escaping ([Tab], Binding<Tab>) -> TabsBar */,
      content: /* @ViewBuilder @escaping (Tab) -> TabContent */
      }
    )
  }
}
```

Check out [documentation comments](Sources/SwiftUITabsView/TabsView.swift) and the included [example app](Example/ExampleApp-iOS/Example.swift).

## 🛠 Development

Open `SwiftUITabsView.xcworkspace` in Xcode (≥13.1) for development.

Use `ExampleApp-iOS` scheme to build and run the example application.

## ☕️ Do you like the project?

<a href="https://www.buymeacoffee.com/darrarski" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" align="right" height="60"/>
</a>

Consider supporting further development and buy me a coffee.

&nbsp;

## 📄 License

Copyright © 2022 Dariusz Rybicki Darrarski

License: [MIT](LICENSE)