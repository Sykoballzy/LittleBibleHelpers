import SwiftUI

/// Central palette + typography. Bright but calming, high contrast,
/// storybook warmth. Everything rounded.
enum Theme {
    // MARK: Palette
    static let cream = Color(red: 1.00, green: 0.97, blue: 0.90)
    static let creamDeep = Color(red: 0.96, green: 0.90, blue: 0.78)
    static let skyTop = Color(red: 0.53, green: 0.81, blue: 0.98)
    static let skyBottom = Color(red: 0.80, green: 0.93, blue: 1.00)
    static let grass = Color(red: 0.58, green: 0.80, blue: 0.38)
    static let grassDeep = Color(red: 0.44, green: 0.68, blue: 0.30)
    static let wood = Color(red: 0.72, green: 0.49, blue: 0.29)
    static let woodDeep = Color(red: 0.55, green: 0.36, blue: 0.20)
    static let sunny = Color(red: 0.99, green: 0.76, blue: 0.22)
    static let coral = Color(red: 0.95, green: 0.53, blue: 0.40)
    static let berry = Color(red: 0.62, green: 0.43, blue: 0.78)
    static let leaf = Color(red: 0.44, green: 0.71, blue: 0.34)
    static let sky = Color(red: 0.33, green: 0.64, blue: 0.90)
    static let outline = Color(red: 0.35, green: 0.23, blue: 0.15)
    static let textDark = Color(red: 0.33, green: 0.22, blue: 0.14)

    // MARK: Typography (SF Rounded everywhere)
    static func title(_ size: CGFloat = 40) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func body(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}
