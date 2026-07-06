import SwiftUI

/// Squish-on-press, the core tactile feel of every button in the app.
struct SquishyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.55), value: configuration.isPressed)
    }
}

/// Big, thick, toddler-friendly button with a "depth" shadow edge.
struct ChunkyButton: View {
    let title: String
    var icon: String? = nil
    var color: Color = Theme.leaf
    var size: CGFloat = 26
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.system(size: size, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, size * 1.2)
            .padding(.vertical, size * 0.6)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: size, style: .continuous)
                        .fill(Color.black.opacity(0.20))
                        .offset(y: size * 0.18)
                    RoundedRectangle(cornerRadius: size, style: .continuous)
                        .fill(color)
                    RoundedRectangle(cornerRadius: size, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 3)
                        .padding(3)
                }
            )
        }
        .buttonStyle(SquishyButtonStyle())
    }
}

struct RoundIconButton: View {
    let systemName: String
    var color: Color = Theme.sunny
    var size: CGFloat = 64
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.18))
                    .offset(y: 4)
                Circle()
                    .fill(color)
                Circle()
                    .strokeBorder(Color.white.opacity(0.4), lineWidth: 3)
                    .padding(3)
                Image(systemName: systemName)
                    .font(.system(size: size * 0.40, weight: .heavy))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(SquishyButtonStyle())
    }
}

/// Ribbon-style title banner used on every screen header.
struct BannerTitle: View {
    let text: String
    var color: Color = Theme.berry
    var textSize: CGFloat = 30

    var body: some View {
        Text(text)
            .font(.system(size: textSize, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, textSize * 1.1)
            .padding(.vertical, textSize * 0.42)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: textSize * 0.65, style: .continuous)
                        .fill(Color.black.opacity(0.18))
                        .offset(y: 4)
                    RoundedRectangle(cornerRadius: textSize * 0.65, style: .continuous)
                        .fill(LinearGradient(colors: [color, color.opacity(0.82)],
                                             startPoint: .top, endPoint: .bottom))
                    RoundedRectangle(cornerRadius: textSize * 0.65, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 3)
                        .padding(3)
                }
            )
    }
}

struct SoftCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
            )
    }
}

extension View {
    func softCard() -> some View {
        modifier(SoftCard())
    }
}
