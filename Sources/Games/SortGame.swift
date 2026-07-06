import SwiftUI

/// Template 5 (NEW): Sort & Classify. Drag each item into the correct labeled
/// bin (e.g. Land / Sea / Sky). Correct drops settle in; wrong drops wiggle and
/// spring back with a gentle hint. Reusable for any "put things in groups" idea.
struct SortGame: View {
    let categories: [SortCategory]
    let items: [SortItem]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private struct Piece: Identifiable, Equatable {
        let id = UUID()
        let art: ArtKey
        let categoryID: String
    }

    @State private var pieces: [Piece] = []
    @State private var placedIDs: Set<UUID> = []
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var dragging: UUID?
    @State private var wrongShake: UUID?
    @State private var saidHint = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let binRects = binFrames(in: geo.size)
            let pieceSize = min(w, h) * 0.16

            ZStack {
                // Bins along the bottom.
                ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                    let contents = pieces
                        .filter { placedIDs.contains($0.id) && $0.categoryID == category.id }
                        .map { ArtViewItem(id: $0.id, art: $0.art) }
                    BinView(category: category, contents: contents)
                        .frame(width: binRects[index].width, height: binRects[index].height)
                        .position(x: binRects[index].midX, y: binRects[index].midY)
                }

                // Unsorted items along the top.
                ForEach(Array(pieces.enumerated()), id: \.element.id) { index, piece in
                    if !placedIDs.contains(piece.id) {
                        let home = trayPosition(index: index, count: pieces.count, size: geo.size)
                        ArtView(key: piece.art)
                            .frame(width: pieceSize, height: pieceSize)
                            .rotationEffect(.degrees(wrongShake == piece.id ? 8 : 0))
                            .offset(dragOffsets[piece.id] ?? .zero)
                            .position(home)
                            .zIndex(dragging == piece.id ? 5 : 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragging = piece.id
                                        dragOffsets[piece.id] = value.translation
                                    }
                                    .onEnded { value in
                                        let drop = CGPoint(x: home.x + value.translation.width,
                                                           y: home.y + value.translation.height)
                                        handleDrop(piece, at: drop, bins: binRects)
                                        dragging = nil
                                    }
                            )
                    }
                }
            }
        }
        .onAppear {
            if pieces.isEmpty {
                pieces = items.map { Piece(art: $0.art, categoryID: $0.categoryID) }.shuffled()
            }
        }
    }

    private func binFrames(in size: CGSize) -> [CGRect] {
        let count = categories.count
        let spacing: CGFloat = 20
        let sideMargin: CGFloat = 30
        let totalSpacing = spacing * CGFloat(count - 1) + sideMargin * 2
        let binWidth = (size.width - totalSpacing) / CGFloat(count)
        let binHeight = size.height * 0.52
        let centerY = size.height - binHeight / 2 - 16
        return (0..<count).map { i in
            let x = sideMargin + CGFloat(i) * (binWidth + spacing)
            return CGRect(x: x, y: centerY - binHeight / 2, width: binWidth, height: binHeight)
        }
    }

    private func trayPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        let fraction = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let x = size.width * (0.12 + 0.76 * fraction)
        return CGPoint(x: x, y: size.height * 0.16)
    }

    private func handleDrop(_ piece: Piece, at point: CGPoint, bins: [CGRect]) {
        for (index, rect) in bins.enumerated() {
            guard rect.contains(point) else { continue }
            if categories[index].id == piece.categoryID {
                place(piece)
            } else {
                reject(piece)
            }
            return
        }
        // Dropped nowhere — glide home.
        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
            dragOffsets[piece.id] = .zero
        }
    }

    private func place(_ piece: Piece) {
        Haptics.success()
        dragOffsets[piece.id] = .zero
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            placedIDs.insert(piece.id)
        }
        if let category = categories.first(where: { $0.id == piece.categoryID }) {
            audio.speak("The \(piece.art.displayName) goes in \(category.title)!")
        }
        if placedIDs.count == pieces.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: onComplete)
        }
    }

    private func reject(_ piece: Piece) {
        Haptics.gentleError()
        withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wrongShake = piece.id }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { dragOffsets[piece.id] = .zero }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation { wrongShake = nil }
        }
        if !saidHint {
            saidHint = true
            audio.speak("Hmm, where does that one go?")
        }
    }
}

/// One labeled drop-bin with the items placed in it so far.
struct BinView: View {
    let category: SortCategory
    let contents: [ArtViewItem]

    var body: some View {
        VStack(spacing: 10) {
            Text(category.title)
                .font(Theme.body(22))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(category.color)
                )

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3),
                      spacing: 6) {
                ForEach(contents) { item in
                    ArtView(key: item.art)
                        .frame(height: 56)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(category.color.opacity(0.5),
                                      style: StrokeStyle(lineWidth: 3, dash: [8, 6]))
                )
        )
    }
}

struct ArtViewItem: Identifiable {
    let id: UUID
    let art: ArtKey
}
