import SwiftUI

@main
struct LittleBibleHelpersApp: App {
    @StateObject private var settings: SettingsStore
    @StateObject private var audio: AudioService
    @StateObject private var progress = ProgressStore()
    @StateObject private var router = AppRouter()

    init() {
        let settings = SettingsStore()
        _settings = StateObject(wrappedValue: settings)
        _audio = StateObject(wrappedValue: AudioService(settings: settings))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(audio)
                .environmentObject(progress)
                .environmentObject(router)
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = settings.meetingModeOn
                }
        }
    }
}
