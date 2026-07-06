import SwiftUI

/// Simple math question gate. Guards the Parent Area and turning off
/// Meeting Mode. Wrong answers shake gently and regenerate.
struct ParentGateView: View {
    let intent: GateIntent

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    @State private var a = 3
    @State private var b = 4
    @State private var options: [Int] = []
    @State private var shake = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { router.dismissGate() }

            VStack(spacing: 22) {
                Text("For Grown-Ups")
                    .font(Theme.title(30))
                    .foregroundColor(Theme.textDark)

                Text("What is \(a) + \(b)?")
                    .font(Theme.body(26))
                    .foregroundColor(Theme.textDark.opacity(0.8))

                HStack(spacing: 22) {
                    ForEach(options, id: \.self) { value in
                        Button {
                            pick(value)
                        } label: {
                            Text("\(value)")
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 88, height: 88)
                                .background(
                                    ZStack {
                                        Circle().fill(Color.black.opacity(0.18)).offset(y: 4)
                                        Circle().fill(Theme.sky)
                                    }
                                )
                        }
                        .buttonStyle(SquishyButtonStyle())
                    }
                }

                Button("Not now") {
                    router.dismissGate()
                }
                .font(Theme.body(18))
                .foregroundColor(Theme.textDark.opacity(0.55))
            }
            .padding(44)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Theme.cream)
                    .shadow(color: .black.opacity(0.25), radius: 18, y: 10)
            )
            .offset(x: shake ? 10 : 0)
        }
        .onAppear(perform: regenerate)
    }

    private func regenerate() {
        a = Int.random(in: 2...6)
        b = Int.random(in: 2...6)
        var opts: Set<Int> = [a + b]
        while opts.count < 3 {
            opts.insert(Int.random(in: 4...12))
        }
        options = Array(opts).shuffled()
    }

    private func pick(_ value: Int) {
        if value == a + b {
            let intent = self.intent
            router.dismissGate()
            switch intent {
            case .openParentArea:
                router.go(.parentArea)
            case .exitMeetingMode:
                settings.meetingModeOn = false
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.12, dampingFraction: 0.25)) {
                shake = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation { shake = false }
                regenerate()
            }
        }
    }
}
