import SwiftUI

/// Template 13 (v2): Pathway. A 7×4 tile board: the walker starts on the
/// left, the goal waits on the right, friendly "blockers" stand in the way.
/// TWO ways to move (both live): tap an open tile next to the walker, or tap
/// the big arrow pad under the board. Collect prizes along the way. Teaches
/// calm, one-step-at-a-time walking — Meet the Speaker, Come to Jesus,
/// Lead the Sheep Home, Visit Grandma.
struct PathwayGame: View {
    let walker: ArtKey
    let goal: ArtKey
    let blocker: ArtKey
    let prize: ArtKey
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    struct Cell: Hashable {
        let col: Int
        let row: Int
    }

    private static let cols = 7
    private static let rows = 4
    private static let start = Cell(col: 0, row: 1)
    private static let goalCell = Cell(col: 6, row: 2)

    /// Predefined layouts (blockers, prizes) — every one has an open path.
    private static let layouts: [(blockers: [Cell], prizes: [Cell])] = [
        (blockers: [Cell(col: 1, row: 0), Cell(col: 1, row: 2), Cell(col: 3, row: 1),
                    Cell(col: 3, row: 3), Cell(col: 5, row: 0), Cell(col: 5, row: 2)],
         prizes: [Cell(col: 2, row: 1), Cell(col: 4, row: 2), Cell(col: 6, row: 1)]),
        (blockers: [Cell(col: 1, row: 1), Cell(col: 2, row: 0), Cell(col: 2, row: 2),
                    Cell(col: 4, row: 1), Cell(col: 4, row: 3), Cell(col: 5, row: 2)],
         prizes: [Cell(col: 1, row: 3), Cell(col: 5, row: 0), Cell(col: 3, row: 1)]),
        (blockers: [Cell(col: 1, row: 2), Cell(col: 2, row: 1), Cell(col: 3, row: 2),
                    Cell(col: 4, row: 0), Cell(col: 5, row: 1), Cell(col: 5, row: 3)],
         prizes: [Cell(col: 2, row: 0), Cell(col: 3, row: 1), Cell(col: 4, row: 2)])
    ]

    @State private var blockers: [Cell] = []
    @State private var prizes: Set<Cell> = []
    @State private var walkerCell = PathwayGame.start
    @State private var collected = 0
    @State private var wigglingBlocker: Cell?
    @State private var saidWalkHint = false
    @State private var done = false
    @State private var pulse = false

    /// Open cells one step away — highlighted so a little one can see
    /// exactly where a step can go.
    private var stepChoices: [Cell] {
        [Cell(col: walkerCell.col + 1, row: walkerCell.row),
         Cell(col: walkerCell.col - 1, row: walkerCell.row),
         Cell(col: walkerCell.col, row: walkerCell.row + 1),
         Cell(col: walkerCell.col, row: walkerCell.row - 1)]
            .filter { isOpen($0) }
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cellSize = min(w / CGFloat(Self.cols) * 0.92, (h * 0.72) / CGFloat(Self.rows))
            let gridW = cellSize * CGFloat(Self.cols)
            let gridH = cellSize * CGFloat(Self.rows)
            let origin = CGPoint(x: (w - gridW) / 2, y: (h * 0.80 - gridH) / 2 + h * 0.02)

            ZStack {
                // Tiles.
                ForEach(0..<Self.cols * Self.rows, id: \.self) { i in
                    let cell = Cell(col: i % Self.cols, row: i / Self.cols)
                    RoundedRectangle(cornerRadius: cellSize * 0.16, style: .continuous)
                        .fill(Color.white.opacity(cell == Self.goalCell ? 0.85 : 0.55))
                        .overlay(
                            RoundedRectangle(cornerRadius: cellSize * 0.16, style: .continuous)
                                .strokeBorder(Theme.outline.opacity(0.12), lineWidth: 2)
                        )
                        .frame(width: cellSize * 0.94, height: cellSize * 0.94)
                        .position(center(of: cell, origin: origin, cellSize: cellSize))
                        .onTapGesture { tapTile(cell) }
                }

                // Where you can step next — gently pulsing rings.
                if !done {
                    ForEach(stepChoices, id: \.self) { cell in
                        Circle()
                            .strokeBorder(Theme.leaf, lineWidth: 4)
                            .frame(width: cellSize * 0.40, height: cellSize * 0.40)
                            .opacity(pulse ? 0.85 : 0.25)
                            .scaleEffect(pulse ? 1.08 : 0.92)
                            .position(center(of: cell, origin: origin, cellSize: cellSize))
                            .allowsHitTesting(false)
                    }
                }

                // Prizes.
                ForEach(Array(prizes), id: \.self) { cell in
                    ArtView(key: prize)
                        .frame(width: cellSize * 0.44, height: cellSize * 0.44)
                        .position(center(of: cell, origin: origin, cellSize: cellSize))
                        .allowsHitTesting(false)
                        .transition(.scale.combined(with: .opacity))
                }

                // Friendly blockers.
                ForEach(blockers, id: \.self) { cell in
                    ArtView(key: blocker)
                        .frame(width: cellSize * 0.82, height: cellSize * 0.82)
                        .rotationEffect(.degrees(wigglingBlocker == cell ? 6 : 0))
                        .position(center(of: cell, origin: origin, cellSize: cellSize))
                        .allowsHitTesting(false)
                }

                // The goal, waiting with open arms.
                ArtView(key: goal)
                    .frame(width: cellSize * 0.95, height: cellSize * 0.95)
                    .position(center(of: Self.goalCell, origin: origin, cellSize: cellSize))
                    .allowsHitTesting(false)

                // The walker — clearly "you": a glowing sunny disc underneath.
                ZStack {
                    Circle()
                        .fill(Theme.sunny.opacity(0.45))
                        .frame(width: cellSize * 0.95, height: cellSize * 0.95)
                    Circle()
                        .strokeBorder(Theme.sunny, lineWidth: 4)
                        .frame(width: cellSize * 0.95, height: cellSize * 0.95)
                    ArtView(key: walker)
                        .frame(width: cellSize * 0.78, height: cellSize * 0.78)
                        .offset(y: pulse ? -3 : 1)
                }
                .position(center(of: walkerCell, origin: origin, cellSize: cellSize))
                .allowsHitTesting(false)
                .zIndex(5)

                // Arrow pad — the second way to walk.
                HStack(spacing: 20) {
                    RoundIconButton(systemName: "arrow.left", color: Theme.sky, size: 62) {
                        step(dc: -1, dr: 0)
                    }
                    RoundIconButton(systemName: "arrow.up", color: Theme.sky, size: 62) {
                        step(dc: 0, dr: -1)
                    }
                    RoundIconButton(systemName: "arrow.down", color: Theme.sky, size: 62) {
                        step(dc: 0, dr: 1)
                    }
                    RoundIconButton(systemName: "arrow.right", color: Theme.sky, size: 62) {
                        step(dc: 1, dr: 0)
                    }
                }
                .position(x: w / 2, y: h * 0.92)

                // Prize counter.
                HStack(spacing: 8) {
                    ArtView(key: prize).frame(width: 28, height: 28)
                    Text("\(collected)")
                        .font(Theme.body(22))
                        .foregroundColor(Theme.textDark)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.75)))
                .position(x: w * 0.92, y: h * 0.05)
            }
        }
        .onAppear {
            if blockers.isEmpty {
                let layout = Self.layouts.randomElement() ?? Self.layouts[0]
                blockers = layout.blockers
                prizes = Set(layout.prizes)
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    // MARK: Geometry

    private func center(of cell: Cell, origin: CGPoint, cellSize: CGFloat) -> CGPoint {
        CGPoint(x: origin.x + (CGFloat(cell.col) + 0.5) * cellSize,
                y: origin.y + (CGFloat(cell.row) + 0.5) * cellSize)
    }

    private func inBounds(_ cell: Cell) -> Bool {
        cell.col >= 0 && cell.col < Self.cols && cell.row >= 0 && cell.row < Self.rows
    }

    private func isOpen(_ cell: Cell) -> Bool {
        inBounds(cell) && !blockers.contains(cell)
    }

    // MARK: Movement (shared by tile taps and the arrow pad)

    private func step(dc: Int, dr: Int) {
        guard !done else { return }
        attemptMove(to: Cell(col: walkerCell.col + dc, row: walkerCell.row + dr))
    }

    private func tapTile(_ cell: Cell) {
        guard !done, cell != walkerCell else { return }
        let isNeighbor = abs(cell.col - walkerCell.col) + abs(cell.row - walkerCell.row) == 1
        guard isNeighbor else {
            if !saidWalkHint {
                saidWalkHint = true
                audio.speak("One step at a time — we walk, we don't run!")
            }
            return
        }
        attemptMove(to: cell)
    }

    private func attemptMove(to cell: Cell) {
        guard inBounds(cell) else {
            Haptics.gentleError()
            return
        }

        if blockers.contains(cell) {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.18, dampingFraction: 0.35)) { wigglingBlocker = cell }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { wigglingBlocker = nil }
            }
            audio.speak("Let's walk around our friend!")
            return
        }

        Haptics.soft()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
            walkerCell = cell
        }

        if prizes.contains(cell) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                prizes.remove(cell)
                collected += 1
            }
            audio.speak("You found one!")
        }

        if cell == Self.goalCell {
            done = true
            Haptics.success()
            audio.speak("You made it — walking so nicely!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: onComplete)
        }
    }
}
