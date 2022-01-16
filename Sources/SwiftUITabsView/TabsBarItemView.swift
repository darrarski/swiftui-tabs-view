import SwiftUI

/// Tabs bar item representing provided tab with a given label.
public struct TabsBarItemView<Tab, Label>: View
where Tab: Equatable,
      Label: View
{
  /// Default tabs bar item with provided label closure.
  ///
  /// - Parameter label: Closure that returns label for provided tab and its selected state.
  /// - Returns: Closure that returns tab bar item for provided tab and its selected state.
  public static func `default`(
    @ViewBuilder label: @escaping (Tab, Bool) -> Label
  ) -> (Tab, Binding<Tab>) -> TabsBarItemView<Tab, Label> {
    { tab, selectedTab in
      TabsBarItemView(
        tab: tab,
        selectedTab: selectedTab,
        label: label
      )
    }
  }

  /// Create tabs bar item.
  ///
  /// - Parameters:
  ///   - tab: Tab for the item.
  ///   - selectedTab: Currently selected tab.
  ///   - label: Closure that returns label for provided tab and its selected state.
  public init(
    tab: Tab,
    selectedTab: Binding<Tab>,
    @ViewBuilder label: @escaping (Tab, Bool) -> Label
  ) {
    self.tab = tab
    self._selectedTab = selectedTab
    self.label = label
  }

  var tab: Tab
  @Binding var selectedTab: Tab
  var label: (Tab, Bool) -> Label

  public var body: some View {
    Button(action: { selectedTab = tab }) {
      Spacer(minLength: 0)

      label(tab, selectedTab == tab)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background {
          if selectedTab == tab {
            Color.clear.background(.thinMaterial)
          }
        }
        .containerShape(RoundedRectangle(cornerRadius: 4))
        .padding(4)

      Spacer(minLength: 0)
    }
  }
}
