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
  ///   - tabsPosition: Describes position of the tabs bar. Default is `.bottom`.
  ///   - ignoresKeyboard: Determines if tabs bar should be covered by keyboard. Default is `true`.
  ///   - frameChangeAnimation: Animation to be used for frame changes. Default is `Animation.default`.
  ///   - tabsBar: Returns tabs bar view for provided tabs and selected tab.
  ///   - content: Retruns content view for provided tab.
  public init(
    tabs: [Tab],
    selectedTab: Binding<Tab>,
    tabsPosition: ToolbarPosition = .bottom,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder tabsBar: @escaping ([Tab], Binding<Tab>) -> TabsBar,
    @ViewBuilder content: @escaping (Tab) -> TabContent
  ) {
    self.tabs = tabs
    self._selectedTab = selectedTab
    self.tabsPosition = tabsPosition
    self.ignoresKeyboard = ignoresKeyboard
    self.frameChangeAnimation = frameChangeAnimation
    self.tabsBar = tabsBar
    self.content = content
  }

  var tabs: [Tab]
  @Binding var selectedTab: Tab
  var tabsPosition: ToolbarPosition
  var ignoresKeyboard: Bool
  var frameChangeAnimation: Animation?
  var tabsBar: ([Tab], Binding<Tab>) -> TabsBar
  var content: (Tab) -> TabContent

  public var body: some View {
    content(selectedTab)
      .toolbar(
        position: tabsPosition,
        ignoresKeyboard: ignoresKeyboard,
        frameChangeAnimation: frameChangeAnimation
      ) {
        tabsBar(tabs, $selectedTab)
      }
  }
}
