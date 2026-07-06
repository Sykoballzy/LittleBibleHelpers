import SwiftUI

/// Template 2: drag and drop. Drag each animal from the meadow onto the ark;
/// animals fly to a deck slot when they land, spring home when they miss.
struct BoardTheArkGame: View {
    let animals: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @Namespace private var boarding

    @State private var boarded: [ArtKey] = []
    @State private var dragOffsets: [ArtKey: CGSize] = [:]
    @State private var draggingAnimal: ArtKey?

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let arkRect = CGRect(x: w * 0.28, y: h * 0.02, width: w * 0.44, height: h * 0.62)
            let animalSize = min(w, h) * 0.26

            ZStack {
                // water beneath the ark
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.78, blue: 0.92).opacity(0.65))
                    .frame(width: arkRect.width * 1.45, height: h * 0.15)
                    .position(x: arkRect.midX, y: arkRect.maxY + h * 0.01)

                ArkArt()
                    .frame(width: arkRect.width, height: arkRect.height)
                    .position(x: arkRect.midX, y: arkRect.midY)

                // animals already on deck
                ForEach(Array(boarded.enumerated()), id: \.element) { index, animal in
                    ArtView(key: animal)
                        .frame(width: arkRect.width * 0.17, height: arkRect.width * 0.17)
                        .matchedGeometryEffect(id: animal, in: boarding)
                        .position(x: arkRect.minX + arkRect.width * (0.20 + 0.20 * CGFloat(index)),
                                  y: arkRect.minY + arkRect.height * 0.33)
                }

                // animals waiting in the meadow
                ForEach(animals.filter { !boarded.contains($0) }, id: \.self) { animal in
                    let index = animals.firstIndex(of: animal) ?? 0
                    let base = CGPoint(x: w * (0.14 + 0.24 * CGFloat(index)), y: h * 0.80)
                    ArtView(key: animal)
                        .frame(width: animalSize, height: animalSize)
                        .matchedGeometryEffect(id: animal, in: boarding)
                        .offset(dragOffsets[animal] ?? .zero)
                        .position(base)
                        .zIndex(draggingAnimal == animal ? 5 : 1)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    draggingAnimal = animal
                                    dragOffsets[animal] = value.translation
                                }
                                .onEnded { value in
                                    let dropPoint = CGPoint(x: base.x + value.translation.width,
                                                            y: base.y + value.translation.height)
                                    if arkRect.insetBy(dx: -30, dy: -30).contains(dropPoint) {
                                        board(animal)
                                    } else {
                                        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                                            dragOffsets[animal] = .zero
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }

    private func board(_ animal: ArtKey) {
        Haptics.soft()
        dragOffsets[animal] = .zero
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            boarded.append(animal)
        }
        audio.speak("The \(animal.displayName) is on the ark!")
        if boarded.count == animals.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: onComplete)
        }
    }
}
