import SwiftUI

extension View {
  func bottomBar<Bar: View>(
    ignoresKeyboard: Bool = true,
    frameChangeAnimation: Animation? = .default,
    @ViewBuilder bar: @escaping () -> Bar
  ) -> some View {
    modifier(BottomBarViewModifier(
      ignoresKeyboard: ignoresKeyboard,
      frameChangeAnimation: frameChangeAnimation,
      bar: bar
    ))
  }
}

struct BottomBarViewModifier<Bar: View>: ViewModifier {
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

  @State var contentFrame: CGRect?
  @State var tabsBarFrame: CGRect?

  var bottomSafeAreaSize: CGSize {
    guard let contentFrame = contentFrame,
          let tabsBarFrame = tabsBarFrame
    else { return .zero }

    var size = contentFrame.intersection(tabsBarFrame).size
    size.width = max(0, size.width)
    size.height = max(0, size.height)

    return size
  }

  func body(content: Content) -> some View {
    ZStack {
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
          Color.clear.frame(
            width: bottomSafeAreaSize.width,
            height: bottomSafeAreaSize.height
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.keyboard, edges: ignoresKeyboard ? .bottom : [])
    }
  }
}

#if DEBUG
struct BottomBarViewModifier_Previews: PreviewProvider {
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
    .bottomBar(ignoresKeyboard: true) {
      Text("Bottom Bar")
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
  }
}
#endif
