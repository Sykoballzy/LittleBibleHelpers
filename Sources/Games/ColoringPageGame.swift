import SwiftUI
import UIKit

/// Template 15 (NEW): PNG coloring page — FREE coloring, no wrong answers.
/// Real flood fill inside the drawn line art: pick any chip, tap any region,
/// it fills perfectly up to the black lines. Recoloring is allowed and fun.
/// The ✨ magic wand is a tool like any chip: select it, tap a region, and
/// that region fills with ITS OWN right color — the child still does the work.
/// The page completes when every region has been colored (any colors).
struct ColoringPageGame: View {
    let page: String
    let seeds: [ColorSeed]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @StateObject private var canvasHolder = CanvasHolder()
    @State private var selected: PaletteColor?
    @State private var wandSelected = false
    @State private var finished = false

    /// Only the page's own colors, in stable order.
    private var palette: [PaletteColor] {
        PaletteColor.allCases.filter { color in seeds.contains { $0.target == color } }
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                if let canvas = canvasHolder.canvas {
                    // Picture card + the live-colored page.
                    let frame = fitRect(imageSize: canvas.size,
                                        in: CGSize(width: w * 0.98, height: h * 0.78))
                    let origin = CGPoint(x: (w - frame.width) / 2, y: h * 0.02)

                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.10), radius: 8, y: 5)
                        .frame(width: frame.width + 20, height: frame.height + 20)
                        .position(x: origin.x + frame.width / 2, y: origin.y + frame.height / 2)

                    Image(uiImage: canvas.image)
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .frame(width: frame.width, height: frame.height)
                        .contentShape(Rectangle())
                        .onTapGesture { location in
                            // location is already in the image frame's local space.
                            tap(at: location, frame: frame, canvas: canvas)
                        }
                        .position(x: origin.x + frame.width / 2, y: origin.y + frame.height / 2)
                } else {
                    Text("This page is still being painted…")
                        .font(Theme.body(20))
                        .foregroundColor(Theme.textDark.opacity(0.6))
                }

                // Palette + the magic wand.
                HStack(spacing: 16) {
                    ForEach(palette, id: \.self) { color in
                        Button {
                            Haptics.soft()
                            selected = color
                            wandSelected = false
                            audio.speak(color.spokenName)
                        } label: {
                            ZStack {
                                Circle().fill(Color.black.opacity(0.15)).offset(y: 3)
                                Circle().fill(color.color)
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: selected == color ? 5 : 2)
                                    .padding(2)
                            }
                            .frame(width: 60, height: 60)
                            .scaleEffect(selected == color ? 1.15 : 1.0)
                        }
                        .buttonStyle(SquishyButtonStyle())
                    }

                    // ✨ The wand tool: tap a spot, it fills with its right color.
                    Button {
                        Haptics.soft()
                        wandSelected = true
                        selected = nil
                        audio.speak("The magic wand! Tap the picture!")
                    } label: {
                        ZStack {
                            Circle().fill(Color.black.opacity(0.18)).offset(y: 3)
                            Circle().fill(Theme.berry)
                            Circle()
                                .strokeBorder(Color.white, lineWidth: wandSelected ? 5 : 2)
                                .padding(2)
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 64, height: 64)
                        .scaleEffect(wandSelected ? 1.15 : 1.0)
                    }
                    .buttonStyle(SquishyButtonStyle())
                    .padding(.leading, 8)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selected)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: wandSelected)
                .position(x: w / 2, y: h * 0.90)
            }
        }
        .onAppear {
            canvasHolder.load(page: page)
        }
    }

    // MARK: Layout

    private func fitRect(imageSize: CGSize, in box: CGSize) -> CGSize {
        let scale = min(box.width / imageSize.width, box.height / imageSize.height)
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }

    // MARK: Interaction

    private func tap(at local: CGPoint, frame: CGSize, canvas: ColoringCanvas) {
        guard !finished else { return }
        guard local.x >= 0, local.y >= 0, local.x <= frame.width, local.y <= frame.height else { return }

        let px = Int(local.x / frame.width * canvas.size.width)
        let py = Int(local.y / frame.height * canvas.size.height)

        if wandSelected {
            switch canvas.wandFill(x: px, y: py, seeds: seeds) {
            case .filled(let color):
                canvasHolder.objectWillChange.send()
                Haptics.success()
                audio.speak(color.spokenName + "!")
                checkCompletion(canvas: canvas)
            case .freeRegion:
                audio.speak("You choose that one!")
            case .line:
                break
            }
            return
        }

        guard let selected else {
            audio.speak("Pick a color first!")
            return
        }

        if canvas.fill(x: px, y: py, color: selected.rgb) {
            canvasHolder.objectWillChange.send()
            Haptics.soft()
            audio.speak(selected.spokenName)
            checkCompletion(canvas: canvas)
        }
    }

    private func checkCompletion(canvas: ColoringCanvas) {
        guard !finished else { return }
        let allColored = seeds.allSatisfy { seed in
            canvas.isColored(x: Int(seed.x * canvas.size.width),
                             y: Int(seed.y * canvas.size.height))
        }
        if allColored {
            finished = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                audio.speak("You colored the whole picture! Beautiful!")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4, execute: onComplete)
        }
    }
}

/// ObservableObject wrapper so SwiftUI refreshes as the canvas repaints.
final class CanvasHolder: ObservableObject {
    @Published var canvas: ColoringCanvas?

    func load(page: String) {
        if canvas == nil {
            canvas = ColoringCanvas(imageName: page)
        }
    }
}

/// The pixel engine: holds the page's RGBA buffer and flood-fills regions
/// bounded by the dark line art.
final class ColoringCanvas {
    private(set) var image: UIImage
    let size: CGSize

    private var pixels: [UInt8]
    private let width: Int
    private let height: Int

    init?(imageName: String) {
        guard let ui = bundledArtImage(imageName), let cg = ui.cgImage else { return nil }
        width = cg.width
        height = cg.height
        size = CGSize(width: width, height: height)
        pixels = [UInt8](repeating: 255, count: width * height * 4)

        let drawn: Bool = pixels.withUnsafeMutableBytes { buffer in
            guard let ctx = CGContext(data: buffer.baseAddress,
                                      width: cg.width, height: cg.height,
                                      bitsPerComponent: 8, bytesPerRow: cg.width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
            else { return false }
            ctx.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
            return true
        }
        guard drawn else { return nil }
        image = ui
    }

    /// Dark line-art pixels bound the fill.
    private func isLine(_ offset: Int) -> Bool {
        let r = Int(pixels[offset]); let g = Int(pixels[offset + 1]); let b = Int(pixels[offset + 2])
        return r + g + b < 330
    }

    /// A region counts as colored once it is neither white paper nor line.
    func isColored(x: Int, y: Int) -> Bool {
        guard x >= 0, x < width, y >= 0, y < height else { return false }
        let o = (y * width + x) * 4
        if isLine(o) { return false }
        let r = Int(pixels[o]); let g = Int(pixels[o + 1]); let b = Int(pixels[o + 2])
        return !(r > 225 && g > 225 && b > 225)
    }

    enum WandResult {
        case filled(PaletteColor)
        case freeRegion
        case line
    }

    /// Scanline BFS flood fill from (x, y). Returns false when tapping a line
    /// or out of bounds. Recoloring an already-colored region works.
    func fill(x: Int, y: Int, color: (r: UInt8, g: UInt8, b: UInt8)) -> Bool {
        guard let region = collectRegion(x: x, y: y) else { return false }
        paint(region.indices, color: color)
        return true
    }

    /// Wand tool: fills the tapped region with its own intended color by
    /// finding the seed that lives inside that region. Regions without a
    /// seed are the child's free choice.
    func wandFill(x: Int, y: Int, seeds: [ColorSeed]) -> WandResult {
        guard let region = collectRegion(x: x, y: y) else { return .line }
        for seed in seeds {
            let sx = Int(seed.x * CGFloat(width))
            let sy = Int(seed.y * CGFloat(height))
            guard sx >= 0, sx < width, sy >= 0, sy < height else { continue }
            if region.membership[sy * width + sx] {
                paint(region.indices, color: seed.target.rgb)
                return .filled(seed.target)
            }
        }
        return .freeRegion
    }

    /// BFS from (x, y) out to the dark lines. Nil when tapping a line or
    /// out of bounds.
    private func collectRegion(x: Int, y: Int) -> (indices: [Int], membership: [Bool])? {
        guard x >= 0, x < width, y >= 0, y < height else { return nil }
        let start = y * width + x
        if isLine(start * 4) { return nil }

        var visited = [Bool](repeating: false, count: width * height)
        var queue = [start]
        visited[start] = true
        var head = 0

        while head < queue.count {
            let idx = queue[head]; head += 1
            let cx = idx % width; let cy = idx / width
            for (nx, ny) in [(cx - 1, cy), (cx + 1, cy), (cx, cy - 1), (cx, cy + 1)] {
                guard nx >= 0, nx < width, ny >= 0, ny < height else { continue }
                let n = ny * width + nx
                if !visited[n] && !isLine(n * 4) {
                    visited[n] = true
                    queue.append(n)
                }
            }
        }
        return (queue, visited)
    }

    private func paint(_ indices: [Int], color: (r: UInt8, g: UInt8, b: UInt8)) {
        for idx in indices {
            let o = idx * 4
            pixels[o] = color.r; pixels[o + 1] = color.g; pixels[o + 2] = color.b; pixels[o + 3] = 255
        }
        rebuildImage()
    }

    private func rebuildImage() {
        let rebuilt: UIImage? = pixels.withUnsafeMutableBytes { buffer in
            guard let ctx = CGContext(data: buffer.baseAddress,
                                      width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
                  let cg = ctx.makeImage()
            else { return nil }
            return UIImage(cgImage: cg)
        }
        if let rebuilt { image = rebuilt }
    }
}
