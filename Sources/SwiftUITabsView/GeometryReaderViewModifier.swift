import SwiftUI

extension View {
  func geometryReader<Geometry: Codable>(
    geometry: @escaping (GeometryProxy) -> Geometry,
    onChange: @escaping (Geometry) -> Void
  ) -> some View {
    modifier(GeometryReaderViewModifier(
      geometry: geometry,
      onChange: onChange
    ))
  }
}

struct GeometryReaderViewModifier<Geometry: Codable>: ViewModifier {
  var geometry: (GeometryProxy) -> Geometry
  var onChange: (Geometry) -> Void

  func body(content: Content) -> some View {
    content
      .background {
        GeometryReader { geometryProxy in
          Color.clear
            .preference(key: GeometryPreferenceKey.self, value: {
              let geometry = self.geometry(geometryProxy)
              let data = try? JSONEncoder().encode(geometry)
              return data
            }())
            .onPreferenceChange(GeometryPreferenceKey.self) { data in
              if let data = data,
                 let geomerty = try? JSONDecoder().decode(Geometry.self, from: data)
              {
                onChange(geomerty)
              }
            }
        }
      }
  }
}

struct GeometryPreferenceKey: PreferenceKey {
  static var defaultValue: Data? = nil

  static func reduce(value: inout Data?, nextValue: () -> Data?) {
    value = nextValue()
  }
}

#if DEBUG
struct GeometryReaderModifier_Previews: PreviewProvider {
  struct Preview: View {
    @State var size: CGSize = .zero

    var body: some View {
      VStack {
        Text("Hello, World!")
          .font(.largeTitle)
          .background(Color.accentColor.opacity(0.15))
          .geometryReader(
            geometry: \.size,
            onChange: { size = $0 }
          )

        Text("\(Int(size.width.rounded())) x \(Int(size.height.rounded()))")
          .font(.caption)
          .frame(width: size.width, height: size.height)
          .background(Color.accentColor.opacity(0.15))
      }
    }
  }

  static var previews: some View {
    Preview()
    #if os(macOS)
      .frame(width: 640, height: 480)
    #endif
  }
}
#endif
