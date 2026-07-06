import SwiftUI

/// Template 4: story sequencing. Tap the tile that comes next; it flies up into
/// the numbered slot and comes alive with a little event animation. Wrong picks
/// wiggle gently — never a harsh "no".
struct SequenceGame: View {
    let steps: [SequenceStep]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @Namespace private var placing

    @State private var placedCount = 0
    @State private var trayOrder: [Int] = []
    @State private var wiggling: Int?
    @State private var justPlaced: Int?
    @State private var saidHint = false

    var body: some View {
        GeometryReader { geo in
            let n = steps.count
            let tileWidth = min((geo.size.width - CGFloat(n + 1) * 22) / CGFloat(n),
                                geo.size.height * 0.40)

            VStack(spacing: geo.size.height * 0.06) {
                // Numbered slots — placed tiles animate.
                HStack(spacing: 18) {
                    ForEach(0..<steps.count, id: \.self) { slot in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.55))
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Theme.outline.opacity(0.35),
                                              style: StrokeStyle(lineWidth: 3, dash: [10, 8]))
                            if slot < placedCount {
                                SequenceTile(step: steps[slot], width: tileWidth * 0.94, alive: true)
                                    .matchedGeometryEffect(id: slot, in: placing)
                                    .scaleEffect(justPlaced == slot ? 1.12 : 1.0)
                            } else {
                                Text("\(slot + 1)")
                                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                                    .foregroundColor(Theme.textDark.opacity(0.28))
                            }
                        }
                        .frame(width: tileWidth, height: tileWidth * 1.08)
                    }
                }

                // Tray of remaining tiles.
                HStack(spacing: 22) {
                    ForEach(trayOrder.filter { $0 >= placedCount }, id: \.self) { index in
                        SequenceTile(step: steps[index], width: tileWidth * 0.9)
                            .matchedGeometryEffect(id: index, in: placing)
                            .rotationEffect(.degrees(wiggling == index ? 5 : 0))
                            .onTapGesture { choose(index) }
                    }
                }
                .frame(height: tileWidth)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            if trayOrder.isEmpty {
                trayOrder = Array(0..<steps.count).shuffled()
            }
        }
    }

    private func choose(_ index: Int) {
        if index == placedCount {
            Haptics.soft()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                placedCount += 1
            }
            let placedSlot = index
            justPlaced = placedSlot
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) { justPlaced = placedSlot }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { if justPlaced == placedSlot { justPlaced = nil } }
            }
            audio.speak(steps[index].caption)
            if placedCount == steps.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: onComplete)
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) {
                wiggling = index
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    wiggling = nil
                }
            }
            if !saidHint {
                saidHint = true
                audio.speak("Hmm, let's find what happened first.")
            }
        }
    }
}

struct SequenceTile: View {
    let step: SequenceStep
    let width: CGFloat
    var alive: Bool = false

    @State private var phase = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                ArtView(key: step.art)
                    .frame(width: width * 0.60, height: width * 0.60)
                    .rotationEffect(.degrees(rock))
                    .offset(y: bob)
                eventFlourish
            }
            .frame(width: width * 0.62, height: width * 0.62)

            Text(step.caption)
                .font(Theme.body(15))
                .foregroundColor(Theme.textDark)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .lineLimit(2)
        }
        .padding(10)
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
        )
        .onAppear {
            guard alive else { return }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                phase = true
            }
        }
    }

    // Gentle per-event motion so each placed beat feels alive.
    private var bob: CGFloat {
        guard alive else { return 0 }
        switch step.art {
        case .ark, .stormCloud: return 0
        default: return phase ? -4 : 2
        }
    }

    private var rock: Double {
        guard alive, step.art == .ark else { return 0 }
        return phase ? 5 : -5
    }

    @ViewBuilder
    private var eventFlourish: some View {
        if alive {
            switch step.art {
            case .stormCloud:
                // falling rain drops
                HStack(spacing: width * 0.10) {
                    ForEach(0..<3, id: \.self) { i in
                        Capsule()
                            .fill(Color(red: 0.42, green: 0.66, blue: 0.90))
                            .frame(width: width * 0.03, height: width * 0.09)
                            .offset(y: phase ? width * 0.18 : width * 0.06)
                            .opacity(phase ? 0.1 : 0.9)
                    }
                }
                .offset(y: width * 0.22)
            case .rainbow:
                Circle()
                    .fill(Color.white)
                    .frame(width: width * 0.08, height: width * 0.08)
                    .opacity(phase ? 0.9 : 0.2)
                    .offset(x: width * 0.20, y: -width * 0.18)
            default:
                EmptyView()
            }
        }
    }
}
