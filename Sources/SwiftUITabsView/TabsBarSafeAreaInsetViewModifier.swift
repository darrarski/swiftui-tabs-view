import SwiftUI

struct TabsBarSafeAreaInsetKey: EnvironmentKey {
  static var defaultValue: CGSize = .zero
}

extension EnvironmentValues {
  var tabsBarSafeAreaInset: CGSize {
    get { self[TabsBarSafeAreaInsetKey.self] }
    set { self[TabsBarSafeAreaInsetKey.self] = newValue }
  }
}

struct TabsBarSafeAreaInsetViewModifier: ViewModifier {
  @Environment(\.toolbarPosition) var position
  @Environment(\.tabsBarSafeAreaInset) var tabsBarSafeAreaInset

  func body(content: Content) -> some View {
    content
      .safeAreaInset(edge: position.verticalEdge) {
        Color.clear.frame(
          width: tabsBarSafeAreaInset.width,
          height: tabsBarSafeAreaInset.height
        )
      }
  }
}

extension View {
  /// Add safe area inset for tabs bar.
  ///
  /// Use this modifier if your tab's content is embedded in `NavigationView`.
  /// Apply it on the content inside the `NavigationView`.
  ///
  /// ```swift
  /// TabsView(
  ///   /* ... */
  ///   content: { tab in
  ///     NavigationView {
  ///       ContentView(for: tab)
  ///         .tabsBarSafeAreaInset()
  ///     }
  ///   }
  /// )
  /// ```
  ///
  /// - Returns: View with additional safe area insets matching the tabs bar.
  public func tabsBarSafeAreaInset() -> some View {
    modifier(TabsBarSafeAreaInsetViewModifier())
  }
}
