# SwiftUI Tabs View

![Swift 5.5](https://img.shields.io/badge/swift-5.5-orange.svg)
![platform iOS 15 | macOS 12.1](https://img.shields.io/badge/platform-iOS_15_|_macOS_12-blue.svg)

SwiftUI tabbed interface. Customizable replacement for `SwiftUI.TabView`.

|iOS|macOS|
|:-:|:-:|
|![Example iOS app light mode](Misc/ExampleApp-iOS-light.gif#gh-light-mode-only)![Example iOS app dark mode](Misc/ExampleApp-iOS-dark.gif#gh-dark-mode-only)|![Example macOS app light mode](Misc/ExampleApp-macOS-light.gif#gh-light-mode-only)![Example macOS app dark mode](Misc/ExampleApp-macOS-dark.gif#gh-dark-mode-only)|

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
      barPosition: /* ToolbarPosition */,
      ignoresKeyboard: /* Bool */,
      frameChangeAnimation: /* Animation? */,
      tabsBar: /* @ViewBuilder @escaping ([Tab], Binding<Tab>) -> TabsBar */,
      content: /* @ViewBuilder @escaping (Tab) -> TabContent */
    )
  }
}
```

Check out [documentation comments](Sources/SwiftUITabsView/TabsView.swift) and the included [example app](Example/ExampleApp/Example.swift).

If your tab's content view is embedded in `NavigationView`, use [tabsBarSafeAreaInset](Sources/SwiftUITabsView/TabsBarSafeAreaInsetViewModifier.swift) modifier to apply safe area insets that matches the tabs bar:

```swift
TabsView(
  /* ... */
  content: { tab in 
    NavigationView {
      ContentView(for: tab)
        .tabsBarSafeAreaInset()
    }
  }
)
```

## 🛠 Development

Open `SwiftUITabsView.xcworkspace` in Xcode (≥13.1) for development.

Use `ExampleApp-iOS` scheme to build and run the iOS example application.

Use `ExampleApp-macOS` scheme to build and run the macOS example application.

## ☕️ Do you like the project?

<a href="https://www.buymeacoffee.com/darrarski" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" align="right" height="60"/>
</a>

Consider supporting further development and buy me a coffee.

&nbsp;

## 📄 License

Copyright © 2022 Dariusz Rybicki Darrarski

License: [MIT](LICENSE)