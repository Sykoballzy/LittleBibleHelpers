import SwiftUI

struct StoryHubView: View {
    let worldID: String

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        if let world = ContentLibrary.world(worldID) {
            ZStack {
                MeadowBackground()

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
                        let rowHeight = (geo.size.height - 20) / 2
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2),
                                  spacing: 20) {
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
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(accent.opacity(0.15))
                    ArtView(key: activity.icon).padding(12)
                }
                .frame(width: 116, height: 116)

                VStack(alignment: .leading, spacing: 7) {
                    Text(activity.title)
                        .font(Theme.body(24))
                        .foregroundColor(Theme.textDark)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.75)
                    Text(activity.subtitle)
                        .font(Theme.body(17))
                        .foregroundColor(Theme.textDark.opacity(0.65))
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .padding(18)
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
