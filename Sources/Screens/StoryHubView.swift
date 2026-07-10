import SwiftUI

struct StoryHubView: View {
    let worldID: String

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        if let world = ContentLibrary.world(worldID) {
            ZStack {
                WorldBackground(worldID: world.id)

                VStack(spacing: 14) {
                    HStack(alignment: .top) {
                        RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                            router.go(.worldMap)
                        }
                        Spacer()
                        VStack(spacing: 5) {
                            BannerTitle(text: world.title, color: world.accent, textSize: 30)
                            Text(world.tagline)
                                .font(Theme.body(18))
                                .foregroundColor(Theme.textDark.opacity(0.8))
                        }
                        Spacer()
                        RoundIconButton(systemName: "speaker.wave.2.fill", color: Theme.leaf) {
                            audio.speak(world.welcomeLine)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    GeometryReader { geo in
                        let cols = world.activities.count > 6 ? 3 : 2
                        let rows = max(1, Int(ceil(Double(world.activities.count) / Double(cols))))
                        let rowHeight = (geo.size.height - 16 * CGFloat(rows - 1)) / CGFloat(rows)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: cols),
                                  spacing: 16) {
                            ForEach(world.activities) { activity in
                                ActivityCard(activity: activity,
                                             accent: world.accent,
                                             done: progress.isCompleted(activity.id)) {
                                    router.go(.game(worldID: world.id, activityID: activity.id))
                                }
                                .frame(height: rowHeight)
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 20)
                }
            }
            .onAppear { audio.speak(world.welcomeLine) }
        }
    }
}

struct ActivityCard: View {
    let activity: Activity
    let accent: Color
    let done: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(accent.opacity(0.15))
                    ArtView(key: activity.icon).padding(10)
                }
                .frame(width: 92, height: 92)

                VStack(alignment: .leading, spacing: 5) {
                    Text(activity.title)
                        .font(Theme.body(21))
                        .foregroundColor(Theme.textDark)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.7)
                        .lineLimit(2)
                    Text(activity.subtitle)
                        .font(Theme.body(15))
                        .foregroundColor(Theme.textDark.opacity(0.65))
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.10), radius: 8, y: 5)
            )
            .overlay(alignment: .topTrailing) {
                if done {
                    ZStack {
                        Circle().fill(Theme.sunny)
                        Circle().strokeBorder(Color.white, lineWidth: 3)
                        StarShape().fill(Color.white).frame(width: 22, height: 22)
                    }
                    .frame(width: 42, height: 42)
                    .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(SquishyButtonStyle())
    }
}
