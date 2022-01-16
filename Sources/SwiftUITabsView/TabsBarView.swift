import SwiftUI

/// Displays bar with items that allows switching between provided tabs.
public struct TabsBarView<Tab, BarItem>: View
where Tab: Equatable & Identifiable,
      BarItem: View
{
  /// Default tabs bar with provided bar item.
  ///
  /// - Parameter barItem: Closure that returns bar item for provided tab and selected tab.
  /// - Returns: Closure that returns tabs bar for provided tabs and selected tab.
  public static func `default`(
    @ViewBuilder barItem: @escaping (Tab, Binding<Tab>) -> BarItem
  ) -> ([Tab], Binding<Tab>) -> TabsBarView<Tab, BarItem> {
    { tabs, selectedTab in
      TabsBarView(
        tabs: tabs,
        selectedTab: selectedTab,
        barItem: barItem
      )
    }
  }

  /// Default tabs bar with provided bar item label.
  ///
  /// - Parameter barItemLabel: Closure that returns label for provided tab and its selected state.
  /// - Returns: Closure that returns tabs bar for provided tabs and selected tab.
  public static func `default`<Label: View>(
    @ViewBuilder barItemLabel: @escaping (Tab, Bool) -> Label
  ) -> ([Tab], Binding<Tab>) -> TabsBarView<Tab, BarItem>
  where BarItem == TabsBarItemView<Tab, Label>
  {
    TabsBarView.default(
      barItem: TabsBarItemView.default(
        label: barItemLabel
      )
    )
  }

  /// Create tabs bar.
  /// 
  /// - Parameters:
  ///   - tabs: Array of tabs.
  ///   - selectedTab: Currently selected tab.
  ///   - barItem: Closure that returns bar item for provided tab and selected tab.
  public init(
    tabs: [Tab],
    selectedTab: Binding<Tab>,
    @ViewBuilder barItem: @escaping (Tab, Binding<Tab>) -> BarItem
  ) {
    self.tabs = tabs
    self._selectedTab = selectedTab
    self.tabItem = barItem
  }

  var tabs: [Tab]
  @Binding var selectedTab: Tab
  var tabItem: (Tab, Binding<Tab>) -> BarItem

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(tabs) { tab in
        tabItem(tab, $selectedTab)
      }
    }
    .overlay(Divider().frame(maxHeight: .infinity, alignment: .top))
    .background(.thinMaterial)
  }
}
