import SwiftUI

struct RootView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()

            screenView
                .id(router.screen)
                .transition(.opacity.combined(with: .scale(scale: 0.97)))

            if settings.meetingModeOn {
                meetingModeBadge
            }

            if let intent = router.gateIntent {
                ParentGateView(intent: intent)
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .onChange(of: settings.meetingModeOn) { isOn in
            UIApplication.shared.isIdleTimerDisabled = isOn
        }
        .onChange(of: settings.activeProfileID) { id in
            progress.switchProfile(id)
        }
        .onAppear {
            progress.switchProfile(settings.activeProfileID)
        }
    }

    @ViewBuilder
    private var screenView: some View {
        switch router.screen {
        case .home:
            HomeView()
        case .worldMap:
            WorldMapView()
        case .storyHub(let worldID):
            StoryHubView(worldID: worldID)
        case .game(let worldID, let activityID):
            GameHostView(worldID: worldID, activityID: activityID)
        case .celebration(let worldID, let activityID):
            CelebrationView(worldID: worldID, activityID: activityID)
        case .collection:
            CollectionView()
        case .parentArea:
            ParentAreaView()
        }
    }

    private var meetingModeBadge: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    router.requestGate(.exitMeetingMode)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "moon.fill")
                        Text("Meeting Mode")
                    }
                    .font(Theme.body(15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Theme.berry.opacity(0.9)))
                }
                .buttonStyle(SquishyButtonStyle())
                .padding(.trailing, 14)
                .padding(.bottom, 10)
            }
        }
        .zIndex(5)
    }
}
