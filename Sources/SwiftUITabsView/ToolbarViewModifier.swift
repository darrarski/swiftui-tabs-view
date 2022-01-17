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

extension View {
  func toolbar<Bar: View>(
    position: ToolbarPosition = .bottom,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder bar: @escaping () -> Bar
  ) -> some View {
    modifier(ToolbarViewModifier(
      position: position,
      ignoresKeyboard: ignoresKeyboard,
      frameChangeAnimation: frameChangeAnimation,
      bar: bar
    ))
  }
}

struct ToolbarViewModifier<Bar: View>: ViewModifier {
  init(
    position: ToolbarPosition = .bottom,
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder bar: @escaping () -> Bar
  ) {
    self.position = position
    self.ignoresKeyboard = ignoresKeyboard
    self.frameChangeAnimation = frameChangeAnimation
    self.bar = bar
  }

  var position: ToolbarPosition
  var ignoresKeyboard: Bool
  var frameChangeAnimation: Animation?
  var bar: () -> Bar

  @State var contentFrame: CGRect?
  @State var tabsBarFrame: CGRect?

  var barSafeArea: CGSize {
    guard let contentFrame = contentFrame,
          let tabsBarFrame = tabsBarFrame
    else { return .zero }

    var size = contentFrame.intersection(tabsBarFrame).size
    size.width = max(0, size.width)
    size.height = max(0, size.height)

    return size
  }

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
        .safeAreaInset(edge: position.verticalEdge) {
          Color.clear.frame(
            width: barSafeArea.width,
            height: barSafeArea.height
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

      bar()
        .geometryReader(
          geometry: { $0.frame(in: .global) },
          onChange: { frame in
            withAnimation(tabsBarFrame == nil ? .none : frameChangeAnimation) {
              tabsBarFrame = frame
            }
          }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: position.frameAlignment)
        .ignoresSafeArea(.keyboard, edges: keyboardSafeAreaEdges)
    }
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
