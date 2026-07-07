import SwiftUI

/// Template 12 (NEW): Tap-to-Color. No brushes, no free-draw, no mess: pick a
/// color chip, then tap the region that should be that color. The palette
/// contains ONLY the colors that belong in the picture, so the finished art
/// always looks right. Wrong region just wiggles the chip — no failure state.
struct TapColorGame: View {
    let regions: [ColorRegion]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    // Picture design space (regions are positioned in these units).
    private static let designWidth: CGFloat = 200
    private static let designHeight: CGFloat = 140

    @State private var selected: PaletteColor?
    @State private var filled: Set<Int> = []
    @State private var chipWiggle: PaletteColor?
    @State private var celebrated = false

    private var palette: [PaletteColor] {
        // Only the picture's own colors, in stable enum order.
        PaletteColor.allCases.filter { color in regions.contains { $0.target == color } }
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let frameW = min(w * 0.72, (h * 0.72) * (Self.designWidth / Self.designHeight))
            let frameH = frameW * (Self.designHeight / Self.designWidth)
            let scale = frameW / Self.designWidth
            let frameOrigin = CGPoint(x: (w - frameW) / 2, y: h * 0.06)

            ZStack {
                // Picture card.
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.10), radius: 8, y: 5)
                    .frame(width: frameW + 28, height: frameH + 28)
                    .position(x: frameOrigin.x + frameW / 2, y: frameOrigin.y + frameH / 2)

                // Regions.
                ForEach(Array(regions.enumerated()), id: \.offset) { index, region in
                    regionView(region, isFilled: filled.contains(index))
                        .position(x: frameOrigin.x + region.x * scale,
                                  y: frameOrigin.y + region.y * scale)
                        .allowsHitTesting(false)
                }

                // One transparent tap layer over the picture with precise
                // math-based hit testing (robust even for overlapping arcs).
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: frameW, height: frameH)
                    .position(x: frameOrigin.x + frameW / 2, y: frameOrigin.y + frameH / 2)
                    .onTapGesture { location in
                        // location is in the tap layer's local coordinates.
                        let point = CGPoint(x: location.x / scale, y: location.y / scale)
                        tapPicture(at: point)
                    }

                // Palette chips.
                HStack(spacing: 18) {
                    ForEach(palette, id: \.self) { color in
                        Button {
                            Haptics.soft()
                            selected = color
                            audio.speak(color.spokenName)
                        } label: {
                            ZStack {
                                Circle().fill(Color.black.opacity(0.15)).offset(y: 3)
                                Circle().fill(color.color)
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: selected == color ? 5 : 2)
                                    .padding(2)
                            }
                            .frame(width: 64, height: 64)
                            .scaleEffect(selected == color ? 1.15 : 1.0)
                            .rotationEffect(.degrees(chipWiggle == color ? 8 : 0))
                        }
                        .buttonStyle(SquishyButtonStyle())
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selected)
                .position(x: w / 2, y: h * 0.90)
            }
        }
    }

    // MARK: Rendering

    /// Coloring-book rendering: every region is white with SOLID dark outlines
    /// until filled — then it takes its color, keeping the outline.
    @ViewBuilder
    private func regionView(_ region: ColorRegion, isFilled: Bool) -> some View {
        let fillColor = isFilled ? region.target.color : Color.white
        let outline = Theme.outline.opacity(0.85)
        switch region.shape {
        case .circle(let diameter):
            Circle()
                .fill(fillColor)
                .overlay(Circle().strokeBorder(outline, lineWidth: 3.5))
                .frame(width: diameter, height: diameter)
                .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isFilled)
        case .ellipse(let width, let height):
            Ellipse()
                .fill(fillColor)
                .overlay(Ellipse().strokeBorder(outline, lineWidth: 3.5))
                .frame(width: width, height: height)
                .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isFilled)
        case .arcBand(let outer, let thickness):
            // Top-half ring: trim(0.5...1) runs 9 o'clock -> 12 -> 3 o'clock.
            // Body stroke sits on the centerline; thin solid strokes mark the
            // outer and inner edges so the empty band reads as line art.
            ZStack {
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .stroke(fillColor, style: StrokeStyle(lineWidth: thickness, lineCap: .butt))
                    .frame(width: outer - thickness, height: outer - thickness)
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .stroke(outline, lineWidth: 3)
                    .frame(width: outer, height: outer)
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .stroke(outline, lineWidth: 3)
                    .frame(width: outer - 2 * thickness, height: outer - 2 * thickness)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isFilled)
        }
    }

    // MARK: Hit testing (in design-space units)

    private func tapPicture(at point: CGPoint) {
        guard let selected else {
            audio.speak("Pick a color first!")
            return
        }
        // Smallest matching region wins so little details are tappable.
        var hitIndex: Int?
        var hitArea = CGFloat.greatestFiniteMagnitude
        for (index, region) in regions.enumerated() where !filled.contains(index) {
            if contains(region, point: point) {
                let area = approxArea(region)
                if area < hitArea {
                    hitArea = area
                    hitIndex = index
                }
            }
        }
        guard let hitIndex else { return }

        if regions[hitIndex].target == selected {
            Haptics.success()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                _ = filled.insert(hitIndex)
            }
            if filled.count == regions.count {
                audio.speak("You colored the whole picture! Beautiful!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onComplete)
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { chipWiggle = selected }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { chipWiggle = nil }
            }
            audio.speak("Hmm, try a different spot!")
        }
    }

    private func contains(_ region: ColorRegion, point: CGPoint) -> Bool {
        let dx = point.x - region.x
        let dy = point.y - region.y
        switch region.shape {
        case .circle(let diameter):
            let r = diameter / 2
            return dx * dx + dy * dy <= r * r
        case .ellipse(let width, let height):
            let rx = width / 2
            let ry = height / 2
            guard rx > 0, ry > 0 else { return false }
            return (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry) <= 1
        case .arcBand(let outer, let thickness):
            // Top-half ring around the region center.
            let rOuter = outer / 2
            let rInner = rOuter - thickness
            let dist = sqrt(dx * dx + dy * dy)
            return dy <= 0 && dist <= rOuter && dist >= rInner
        }
    }

    private func approxArea(_ region: ColorRegion) -> CGFloat {
        switch region.shape {
        case .circle(let d): return d * d
        case .ellipse(let w, let h): return w * h
        case .arcBand(let outer, let thickness): return outer * thickness
        }
    }
}
