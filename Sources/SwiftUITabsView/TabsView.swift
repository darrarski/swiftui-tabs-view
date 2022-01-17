import SwiftUI

/// Displays content for selected tab and allows switching between provided tabs.
public struct TabsView<Tab, TabContent, TabsBar>: View
where Tab: Equatable & Identifiable,
      TabContent: View,
      TabsBar: View
{
  /// Create tabs.
  ///
  /// - Parameters:
  ///   - tabs: Array of tabs.
  ///   - selectedTab: Currently selected tab.
  ///   - barPosition: Position of the tabs bar. Default is `.bottom`.
  ///   - ignoresKeyboard: Determines if tabs bar should be covered by keyboard. Default is `true`.
  ///   - frameChangeAnimation: Animation to be used for frame changes. Default is `Animation.default`.
  ///   - tabsBar: Returns tabs bar view with provided position, tabs, and selected tab.
  ///   - content: Retruns content view for provided tab.
  public init(
    tabs: [Tab],
    selectedTab: Binding<Tab>,
    barPosition: ToolbarPosition = .bottom,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder tabsBar: @escaping (ToolbarPosition, [Tab], Binding<Tab>) -> TabsBar,
    @ViewBuilder content: @escaping (Tab) -> TabContent
  ) {
    self.tabs = tabs
    self._selectedTab = selectedTab
    self.barPosition = barPosition
    self.ignoresKeyboard = ignoresKeyboard
    self.frameChangeAnimation = frameChangeAnimation
    self.tabsBar = tabsBar
    self.content = content
  }

  var tabs: [Tab]
  @Binding var selectedTab: Tab
  var barPosition: ToolbarPosition
  var ignoresKeyboard: Bool
  var frameChangeAnimation: Animation?
  var tabsBar: (ToolbarPosition, [Tab], Binding<Tab>) -> TabsBar
  var content: (Tab) -> TabContent

  public var body: some View {
    content(selectedTab)
      .toolbar(
        position: barPosition,
        ignoresKeyboard: ignoresKeyboard,
        frameChangeAnimation: frameChangeAnimation
      ) {
        tabsBar(barPosition, tabs, $selectedTab)
      }
  }
}
