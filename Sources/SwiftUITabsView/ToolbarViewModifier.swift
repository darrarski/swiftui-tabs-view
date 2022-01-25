import SwiftUI

/// Describes position of the toolbar.
public enum ToolbarPosition: Equatable {
  /// Bar positioned above the content.
  case top

  /// Tabs bar positioned below the content.
  case bottom

  var verticalEdge: VerticalEdge {
    switch self {
    case .top: return .top
    case .bottom: return .bottom
    }
  }

  var frameAlignment: Alignment {
    switch self {
    case .top: return .top
    case .bottom: return .bottom
    }
  }
}

struct ToolbarPositionKey: EnvironmentKey {
  static var defaultValue: ToolbarPosition = .bottom
}

extension EnvironmentValues {
  var toolbarPosition: ToolbarPosition {
    get { self[ToolbarPositionKey.self] }
    set { self[ToolbarPositionKey.self] = newValue }
  }
}

extension View {
  func toolbar<Bar: View>(
    position: ToolbarPosition = .bottom,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder bar: @escaping () -> Bar
  ) -> some View {
    modifier(ToolbarViewModifier(
      ignoresKeyboard: ignoresKeyboard,
      frameChangeAnimation: frameChangeAnimation,
      bar: bar
    ))
      .environment(\.toolbarPosition, position)
  }
}

struct ToolbarViewModifier<Bar: View>: ViewModifier {
  init(
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder bar: @escaping () -> Bar
  ) {
    self.ignoresKeyboard = ignoresKeyboard
    self.frameChangeAnimation = frameChangeAnimation
    self.bar = bar
  }

  var ignoresKeyboard: Bool
  var frameChangeAnimation: Animation?
  var bar: () -> Bar

  @Environment(\.toolbarPosition) var position
  @State var contentFrame: CGRect?
  @State var tabsBarFrame: CGRect?
  @State var tabsBarSafeAreaInset: CGSize = .zero

  var keyboardSafeAreaEdges: Edge.Set {
    guard ignoresKeyboard else { return [] }
    switch position {
    case .top: return .top
    case .bottom: return .bottom
    }
  }

  func body(content: Content) -> some View {
    ZStack {
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabsBarSafeAreaInset()
        .geometryReader(
          geometry: { $0.frame(in: .global) },
          onChange: { frame in
            withAnimation(contentFrame == nil ? .none : frameChangeAnimation) {
              contentFrame = frame
              tabsBarSafeAreaInset = makeTabsBarSafeAreaInset()
            }
          }
        )

      bar()
        .geometryReader(
          geometry: { $0.frame(in: .global) },
          onChange: { frame in
            withAnimation(tabsBarFrame == nil ? .none : frameChangeAnimation) {
              tabsBarFrame = frame
              tabsBarSafeAreaInset = makeTabsBarSafeAreaInset()
            }
          }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: position.frameAlignment)
        .ignoresSafeArea(.keyboard, edges: keyboardSafeAreaEdges)
    }
    .environment(\.tabsBarSafeAreaInset, tabsBarSafeAreaInset)
  }

  func makeTabsBarSafeAreaInset() -> CGSize {
    guard let contentFrame = contentFrame,
          let tabsBarFrame = tabsBarFrame
    else { return .zero }

    var size = contentFrame.intersection(tabsBarFrame).size
    size.width = max(0, size.width)
    size.height = max(0, size.height)

    return size
  }
}

#if DEBUG
struct ToolbarViewModifier_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        ForEach(1..<21) { row in
          VStack(alignment: .leading, spacing: 0) {
            Text("Row #\(row)")
            TextField("Text", text: .constant(""))
          }
          .padding()
          .background(Color.accentColor.opacity(row % 2 == 0 ? 0.1 : 0.15))
        }
      }
    }
    .toolbar(ignoresKeyboard: true) {
      Text("Bottom Bar")
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
    #if os(macOS)
    .frame(width: 640, height: 480)
    #endif
  }
}
#endif
