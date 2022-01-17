import SwiftUI
import SwiftUITabsView

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ExampleTabsView()
    }
  }
}

enum ExampleTab: String, Equatable, Identifiable, CaseIterable {
  case red, green, blue

  var id: Self { self }

  var color: Color {
    switch self {
    case .red: return Color(.systemRed)
    case .green: return Color(.systemGreen)
    case .blue: return Color(.systemBlue)
    }
  }

  var title: String {
    switch self {
    case .red: return "Red"
    case .green: return "Green"
    case .blue: return "Blue"
    }
  }

  func systemImageName(selected isSelected: Bool) -> String {
    var components = [String]()
    switch self {
    case .red: components.append("r")
    case .green: components.append("g")
    case .blue: components.append("b")
    }
    components.append("square")
    if isSelected {
      components.append("fill")
    }
    return components.joined(separator: ".")
  }
}

struct ExampleTabView: View {
  init(
    tab: ExampleTab,
    barPosition: Binding<ToolbarPosition>,
    ignoreKeyboard: Binding<Bool>,
    animateFrameChanges: Binding<Bool>,
    text: Binding<String>
  ) {
    self.tab = tab
    self._barPosition = barPosition
    self._ignoreKeyboard = ignoreKeyboard
    self._animateFrameChanges = animateFrameChanges
    self._text = text
  }

  var tab: ExampleTab
  @Binding var barPosition: ToolbarPosition
  @Binding var ignoreKeyboard: Bool
  @Binding var animateFrameChanges: Bool
  @Binding var text: String

  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack {
          Text(tab.title)
            .font(.largeTitle)

          Picker("Tabs bar position", selection: $barPosition) {
            Text("Bottom").tag(ToolbarPosition.bottom)
            Text("Top").tag(ToolbarPosition.top)
          }
          .pickerStyle(.segmented)

          #if os(iOS)
          Toggle("Ignore keyboard", isOn: $ignoreKeyboard.animation(
            animateFrameChanges ? .default : .none
          ))
          Toggle("Animate frame changes", isOn: $animateFrameChanges)
          #endif

          Spacer()

          #if os(iOS)
          TextField("Text", text: $text)
          #endif
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial)
        .mask(RoundedRectangle(cornerRadius: 10))
        .padding()
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
    .background(tab.color.saturation(1/3).ignoresSafeArea())
  }
}

struct ExampleTabsView: View {
  @State var selectedTab: ExampleTab = .red
  @State var tabsPosition: ToolbarPosition = .bottom
  @State var ignoreKeyboard: Bool = true
  @State var animateFrameChanges: Bool = true
  @State var texts: [ExampleTab: String] = [:]

  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    TabsView(
      tabs: ExampleTab.allCases,
      selectedTab: $selectedTab,
      barPosition: tabsPosition,
      ignoresKeyboard: ignoreKeyboard,
      frameChangeAnimation: animateFrameChanges ? .default : .none,
      tabsBar: TabsBarView.default { tab, isSelected in
        VStack(spacing: 4) {
          Image(systemName: tab.systemImageName(selected: isSelected))
          Text(tab.title)
            .font(.footnote)
        }
        .foregroundColor(tab.color)
        .saturation(0.8)
        .brightness(colorScheme == .dark ? 0.2 : -0.2)
      },
      content: { tab in
        ExampleTabView(
          tab: tab,
          barPosition: $tabsPosition.animation(),
          ignoreKeyboard: $ignoreKeyboard,
          animateFrameChanges: $animateFrameChanges,
          text: .init(
            get: { texts[tab, default: ""] },
            set: { texts[tab] = $0 }
          )
        )
      }
    )
    #if os(macOS)
      .frame(width: 640, height: 480)
    #endif
  }
}

#if DEBUG
struct ExampleTabsView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleTabsView()
  }
}
#endif
