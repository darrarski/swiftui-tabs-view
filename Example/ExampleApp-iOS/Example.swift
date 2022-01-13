import SwiftUI
import SwiftUITabsView

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ExampleView()
    }
  }
}

struct ExampleView: View {
  var body: some View {
    TabsView()
  }
}

#if DEBUG
struct ExampleView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleView()
  }
}
#endif
