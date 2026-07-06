import SwiftUI

/// Resolves a (world, activity) pair and hosts the matching game template.
/// Completion is handled here in one place: record progress, celebrate.
struct GameHostView: View {
    let worldID: String
    let activityID: String

    @EnvironmentObject private var router: AppRouter

    var body: some View {
        if let pair = ContentLibrary.lookup(worldID: worldID, activityID: activityID) {
            GameScreen(world: pair.world, activity: pair.activity)
        } else {
            Color.clear
                .onAppear { router.go(.home) }
        }
    }
}

private struct GameScreen: View {
    let world: BibleWorld
    let activity: Activity

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        ZStack {
            MeadowBackground()
            VStack(spacing: 6) {
                GameTopBar(
                    title: activity.title,
                    subtitle: activity.subtitle,
                    accent: world.accent,
                    onBack: { router.go(.storyHub(worldID: world.id)) },
                    onSpeak: { audio.speak(activity.introLine) }
                )
                gameBody
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { audio.speak(activity.introLine) }
    }

    @ViewBuilder
    private var gameBody: some View {
        switch activity.spec {
        case .matchPairs(let pool):
            MatchPairsGame(pool: pool, onComplete: finish)
        case .boardTheArk(let animals):
            BoardTheArkGame(animals: animals, onComplete: finish)
        case .count(let item, let littleTarget, let bigTarget):
            CountGame(item: item,
                      target: settings.ageBand == .littleOnes ? littleTarget : bigTarget,
                      onComplete: finish)
        case .sequence(let steps):
            SequenceGame(steps: steps, onComplete: finish)
        }
    }

    private func finish() {
        progress.complete(activity, in: world)
        Haptics.success()
        router.go(.celebration(worldID: world.id, activityID: activity.id))
    }
}

struct GameTopBar: View {
    let title: String
    let subtitle: String
    let accent: Color
    let onBack: () -> Void
    let onSpeak: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            RoundIconButton(systemName: "arrow.backward", color: Theme.sunny, action: onBack)
            Spacer()
            VStack(spacing: 5) {
                BannerTitle(text: title, color: accent, textSize: 26)
                Text(subtitle)
                    .font(Theme.body(18))
                    .foregroundColor(Theme.textDark)
            }
            Spacer()
            RoundIconButton(systemName: "speaker.wave.2.fill", color: Theme.leaf, action: onSpeak)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}
