import SwiftUI

/// Template 2 (v2): drag and drop with a purpose. Animals come **two by two**
/// (the Bible detail), each reacts as it boards, the ark fills up, and when the
/// last pair is aboard the rain comes and a rainbow appears — a real payoff.
struct BoardTheArkGame: View {
    let animals: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @Namespace private var boarding

    private struct Passenger: Identifiable, Equatable {
        let id = UUID()
        let art: ArtKey
    }

    private enum Phase { case boarding, payoff }

    @State private var passengers: [Passenger] = []
    @State private var boarded: [Passenger] = []
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var dragging: UUID?
    @State private var phase: Phase = .boarding
    @State private var showRainbow = false
    /// The species whose pair is mid-way — its partner must board next.
    @State private var activeSpecies: ArtKey?
    @State private var nudged: UUID?
    @State private var bob = false
    @State private var arkBounce = false

    private var total: Int { passengers.count }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let arkRect = CGRect(x: w * 0.30, y: h * 0.04, width: w * 0.40, height: h * 0.52)
            let animalSize = min(w, h) * 0.20

            ZStack {
                // Water beneath the ark.
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.78, blue: 0.92).opacity(0.65))
                    .frame(width: arkRect.width * 1.5, height: h * 0.14)
                    .position(x: arkRect.midX, y: arkRect.maxY + h * 0.02)

                // Rain during the payoff.
                if phase == .payoff {
                    StormCloudArt()
                        .frame(width: w * 0.3, height: w * 0.3)
                        .position(x: arkRect.midX, y: arkRect.minY - h * 0.02)
                        .transition(.opacity)
                }

                // Boarding ramp up to the ark.
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: arkRect.width * 0.55, height: 16)
                    .rotationEffect(.degrees(26))
                    .position(x: arkRect.midX - arkRect.width * 0.05, y: arkRect.maxY + h * 0.05)

                ArtView(key: .ark)
                    .frame(width: arkRect.width, height: arkRect.height)
                    .scaleEffect(arkBounce ? 1.05 : 1.0)
                    .position(x: arkRect.midX, y: arkRect.midY)

                // Rainbow payoff arcs over the ark.
                if showRainbow {
                    RainbowArt()
                        .frame(width: arkRect.width * 1.6, height: arkRect.width * 1.0)
                        .position(x: arkRect.midX, y: arkRect.minY + h * 0.02)
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                }

                // Animals already on deck.
                ForEach(Array(boarded.enumerated()), id: \.element.id) { index, passenger in
                    let perRow = 4
                    let col = index % perRow
                    let row = index / perRow
                    ArtView(key: passenger.art)
                        .frame(width: arkRect.width * 0.20, height: arkRect.width * 0.20)
                        .matchedGeometryEffect(id: passenger.id, in: boarding)
                        .position(
                            x: arkRect.minX + arkRect.width * (0.18 + 0.21 * CGFloat(col)),
                            y: arkRect.minY + arkRect.height * (0.34 + 0.20 * CGFloat(row))
                        )
                }

                // Animals waiting in the meadow (fixed home slots so they don't jump).
                ForEach(Array(passengers.enumerated()), id: \.element.id) { index, passenger in
                    if !boarded.contains(passenger) {
                        let home = waitingPosition(index: index, count: total, size: geo.size)
                        ArtView(key: passenger.art)
                            .frame(width: animalSize, height: animalSize)
                            .matchedGeometryEffect(id: passenger.id, in: boarding)
                            .rotationEffect(.degrees(nudged == passenger.id ? 8 : 0))
                            .offset(dragOffsets[passenger.id] ?? .zero)
                            .offset(y: dragging == passenger.id ? 0 : (bob ? -5 : 0))
                            .position(home)
                            .zIndex(dragging == passenger.id ? 5 : 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        guard phase == .boarding else { return }
                                        dragging = passenger.id
                                        dragOffsets[passenger.id] = value.translation
                                    }
                                    .onEnded { value in
                                        let drop = CGPoint(x: home.x + value.translation.width,
                                                           y: home.y + value.translation.height)
                                        let onArk = arkRect.insetBy(dx: -40, dy: -40).contains(drop)
                                        if onArk && canBoard(passenger) {
                                            board(passenger)
                                        } else if onArk {
                                            rejectWrongPair(passenger)
                                        } else {
                                            withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                                                dragOffsets[passenger.id] = .zero
                                            }
                                        }
                                        dragging = nil
                                    }
                            )
                    }
                }

                // Progress: how many aboard.
                ProgressPips(filled: boarded.count, total: total)
                    .position(x: w / 2, y: h * 0.95)
            }
        }
        .onAppear {
            setUp()
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { bob = true }
        }
    }

    private func setUp() {
        guard passengers.isEmpty else { return }
        // Two of each animal — two by two.
        passengers = animals.flatMap { [Passenger(art: $0), Passenger(art: $0)] }.shuffled()
    }

    private func waitingPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        let fraction = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let x = size.width * (0.10 + 0.80 * fraction)
        return CGPoint(x: x, y: size.height * 0.82)
    }

    /// You may board any species when no pair is in progress, otherwise only the
    /// partner of the species you already started.
    private func canBoard(_ passenger: Passenger) -> Bool {
        guard let active = activeSpecies else { return true }
        return passenger.art == active
    }

    private func board(_ passenger: Passenger) {
        Haptics.soft()
        dragOffsets[passenger.id] = .zero
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            boarded.append(passenger)
        }
        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { arkBounce = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { arkBounce = false }
        }

        // Track the pair: first of a species starts it, second completes it.
        let sameSpecies = boarded.filter { $0.art == passenger.art }.count
        if sameSpecies == 2 {
            activeSpecies = nil
            audio.speak("Two \(passenger.art.pluralName) are safe on the ark!")
        } else {
            activeSpecies = passenger.art
            audio.speak("Now bring the other \(passenger.art.displayName)!")
        }

        if boarded.count == total {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: startPayoff)
        }
    }

    private func rejectWrongPair(_ passenger: Passenger) {
        Haptics.gentleError()
        withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { nudged = passenger.id }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { dragOffsets[passenger.id] = .zero }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation { nudged = nil }
        }
        if let active = activeSpecies {
            audio.speak("Let's find the other \(active.displayName) first!")
        }
    }

    private func startPayoff() {
        withAnimation(.easeInOut(duration: 0.5)) { phase = .payoff }
        audio.speak("Everyone is safe inside!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                phase = .boarding // clear the rain
                showRainbow = true
            }
            audio.speak("Look — a beautiful rainbow!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2, execute: onComplete)
    }
}

/// A row of pips that fill as items are placed — reusable progress indicator.
struct ProgressPips: View {
    let filled: Int
    let total: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<total, id: \.self) { i in
                Circle()
                    .fill(i < filled ? Theme.leaf : Color.white.opacity(0.8))
                    .overlay(Circle().strokeBorder(Theme.outline.opacity(0.2), lineWidth: 2))
                    .frame(width: 22, height: 22)
                    .scaleEffect(i < filled ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: filled)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white.opacity(0.5)))
    }
}
