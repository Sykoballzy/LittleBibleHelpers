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
            WorldBackground(worldID: world.id)
            VStack(spacing: 6) {
                GameTopBar(
                    title: activity.title,
                    subtitle: activity.subtitle,
                    scripture: activity.scripture,
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
        case .count(let items, let center, let labels, let littleRange, let bigRange):
            CountGame(items: items, center: center, labels: labels,
                      range: settings.ageBand == .littleOnes ? littleRange : bigRange,
                      onComplete: finish)
        case .sequence(let steps):
            SequenceGame(steps: steps, onComplete: finish)
        case .sortClassify(let categories, let items):
            SortGame(categories: categories, items: items, onComplete: finish)
        case .actionSequence(let start, let steps):
            ActionSequenceGame(start: start, steps: steps, onComplete: finish)
        case .findIt(let items):
            FindItGame(items: items, onComplete: finish)
        case .shadowMatch(let items):
            ShadowMatchGame(items: items, onComplete: finish)
        case .deliver(let item, let source, let targets, let deliverLine):
            DeliverGame(item: item, source: source, targets: targets,
                        deliverLine: deliverLine, onComplete: finish)
        case .gather(let item, let count, let container, let scenery, let decoyGuard, let decoyLine):
            GatherGame(item: item, count: count, container: container, scenery: scenery,
                       decoyGuard: decoyGuard, decoyLine: decoyLine, onComplete: finish)
        case .giveNumber(let item, let container, let distractors, let littleRange, let bigRange):
            GiveNumberGame(item: item, container: container, distractors: distractors,
                           range: settings.ageBand == .littleOnes ? littleRange : bigRange,
                           onComplete: finish)
        case .tapColor(let regions):
            TapColorGame(regions: regions, onComplete: finish)
        case .pathway(let walker, let goal, let blocker, let prize):
            PathwayGame(walker: walker, goal: goal, blocker: blocker, prize: prize,
                        onComplete: finish)
        case .cleanUp(let surface, let tasks):
            CleanUpGame(surface: surface, tasks: tasks, onComplete: finish)
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
    var scripture: String? = nil
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
                // For the grown-up reading along in family worship.
                if let scripture {
                    HStack(spacing: 5) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 11))
                        Text(scripture)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(Theme.textDark.opacity(0.55))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.65)))
                }
            }
            Spacer()
            RoundIconButton(systemName: "speaker.wave.2.fill", color: Theme.leaf, action: onSpeak)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}
