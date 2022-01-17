import SwiftUI

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ExampleTabsView()
    }
  }
}

struct ExampleTabsView: View {
  var body: some View {
    Text("ExampleTabsView")
      .frame(width: 640, height: 480)
  }
}

#if DEBUG
struct ExampleTabsView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleTabsView()
  }
}
#endif
