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
  ///   - ignoresKeyboard: Determines if tabs bar should be covered by keyboard. Default is `true`.
  ///   - frameChangeAnimation: Animation to be used for frame changes. Default is `Animation.default`.
  ///   - tabsBar: Returns tabs bar view for provided tabs and selected tab.
  ///   - content: Retruns content view for provided tab.
  public init(
    tabs: [Tab],
    selectedTab: Binding<Tab>,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder tabsBar: @escaping ([Tab], Binding<Tab>) -> TabsBar,
    @ViewBuilder content: @escaping (Tab) -> TabContent
  ) {
    self.tabs = tabs
    self._selectedTab = selectedTab
    self.ignoresKeyboard = ignoresKeyboard
    self.frameChangeAnimation = frameChangeAnimation
    self.tabsBar = tabsBar
    self.content = content
  }

  var tabs: [Tab]
  @Binding var selectedTab: Tab
  var ignoresKeyboard: Bool
  var frameChangeAnimation: Animation?
  var tabsBar: ([Tab], Binding<Tab>) -> TabsBar
  var content: (Tab) -> TabContent

  @State var contentFrame: CGRect?
  @State var tabsBarFrame: CGRect?

  var bottomSafeAreaSize: CGSize {
    guard let contentFrame = contentFrame,
          let tabsBarFrame = tabsBarFrame
    else { return .zero }
    return contentFrame.intersection(tabsBarFrame).size
  }

  public var body: some View {
    ZStack {
      content(selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
          Color.clear.frame(
            width: max(0, bottomSafeAreaSize.width),
            height: max(0, bottomSafeAreaSize.height)
          )
        }
        .geometryReader(
          geometry: { $0.frame(in: .global) },
          onChange: { frame in
            withAnimation(contentFrame == nil ? .none : frameChangeAnimation) {
              contentFrame = frame
            }
          }
        )

      tabsBar(tabs, $selectedTab)
        .geometryReader(
          geometry: { $0.frame(in: .global) },
          onChange: { frame in
            withAnimation(tabsBarFrame == nil ? .none : frameChangeAnimation) {
              tabsBarFrame = frame
            }
          }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.keyboard, edges: ignoresKeyboard ? .bottom : [])
    }
  }
}
