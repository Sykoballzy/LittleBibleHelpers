import SwiftUI

/// Template 4: story sequencing. Tap the tile that comes next; it flies up
/// into the numbered slot. Wrong picks wiggle gently — never a harsh "no."
struct SequenceGame: View {
    let steps: [SequenceStep]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @Namespace private var placing

    @State private var placedCount = 0
    @State private var trayOrder: [Int] = []
    @State private var wiggling: Int?
    @State private var saidHint = false

    var body: some View {
        GeometryReader { geo in
            let tileWidth = min(geo.size.width * 0.22, geo.size.height * 0.42)

            VStack(spacing: geo.size.height * 0.07) {
                // numbered slots
                HStack(spacing: 26) {
                    ForEach(0..<steps.count, id: \.self) { slot in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.55))
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Theme.outline.opacity(0.35),
                                              style: StrokeStyle(lineWidth: 3, dash: [10, 8]))
                            if slot < placedCount {
                                SequenceTile(step: steps[slot], width: tileWidth * 0.94)
                                    .matchedGeometryEffect(id: slot, in: placing)
                            } else {
                                Text("\(slot + 1)")
                                    .font(.system(size: 46, weight: .heavy, design: .rounded))
                                    .foregroundColor(Theme.textDark.opacity(0.28))
                            }
                        }
                        .frame(width: tileWidth, height: tileWidth * 1.08)
                    }
                }

                // tray of remaining tiles
                HStack(spacing: 30) {
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
            audio.speak(steps[index].caption)
            if placedCount == steps.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onComplete)
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

    var body: some View {
        VStack(spacing: 6) {
            ArtView(key: step.art)
                .frame(width: width * 0.60, height: width * 0.60)
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
    }
}
