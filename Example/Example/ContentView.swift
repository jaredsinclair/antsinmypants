import SwiftUI
import AntsInMyPants

struct ContentView: View {
    @State var wiggle: CGFloat = 1.0
    @State var iterations: CFTimeInterval = 1.0
    @State var perspective: CGFloat = 1.0

    var body: some View {
        ReadableContentContainer(emsPerLine: 35) { width in
            VStack(spacing: 32) {
                AntiAliasedRectangle(cornerRadius: 20) {
                    Image("ants")
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .antsInMyPants(
                    wiggleExaggeration: $wiggle,
                    iterationsPerSecond: $iterations,
                    perspectiveExaggeration: $perspective
                )
                .shadow(
                    color: .black.opacity(0.333),
                    radius: 24, x: 0, y: 24
                )

                Text("Hint: try setting the iterations per second to something super slow, around `0.1`, to mimic the animations seen in the iOS and iPadOS home screen widget pickers.")
                    .foregroundColor(.secondary)

                VStack(spacing: 4) {
                    HStack {
                        Text("\(Double(wiggle).formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $wiggle, in: 0...5.0)
                        Image(systemName: "tornado").foregroundColor(.hotPink)
                    }
                    HStack {
                        Text("\(Double(iterations).formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $iterations, in: 0...5.0)
                        Image(systemName: "clock").foregroundColor(.hotPink)
                    }
                    HStack {
                        Text("\(Double(perspective).formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $perspective, in: 0...5.0)
                        Image(systemName: "video").foregroundColor(.hotPink)
                    }
                }
                .font(.footnote.monospaced())

                Button {
                    wiggle = 1
                    iterations = 1
                    perspective = 1
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }

            }
        }
        .tint(.hotPink)
    }
}

extension Color {
    static var hotPink = Color(.displayP3, red: 1, green: 0, blue: 1, opacity: 1)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
