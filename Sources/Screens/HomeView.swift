import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        ZStack {
            MeadowBackground()

            // decorative friends in the meadow
            GeometryReader { geo in
                Group {
                    ArtView(key: .sheep)
                        .frame(width: 120, height: 120)
                        .position(x: geo.size.width * 0.11, y: geo.size.height * 0.74)
                    ArtView(key: .giraffe)
                        .frame(width: 130, height: 130)
                        .position(x: geo.size.width * 0.89, y: geo.size.height * 0.70)
                    ArtView(key: .bird)
                        .frame(width: 90, height: 90)
                        .position(x: geo.size.width * 0.22, y: geo.size.height * 0.30)
                }
                .allowsHitTesting(false)
            }

            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Little Bible Helpers")
                        .font(Theme.title(58))
                        .foregroundColor(Theme.textDark)
                    HStack(spacing: 10) {
                        HeartShape().fill(Theme.coral).frame(width: 20, height: 18)
                        Text("Games to Learn and Grow")
                            .font(Theme.body(24))
                            .foregroundColor(Theme.textDark.opacity(0.8))
                        HeartShape().fill(Theme.coral).frame(width: 20, height: 18)
                    }
                }
                .padding(.horizontal, 44)
                .padding(.vertical, 26)
                .background(
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(Theme.cream.opacity(0.92))
                        .shadow(color: .black.opacity(0.10), radius: 12, y: 6)
                )

                ChunkyButton(title: "Play", icon: "play.fill", color: Theme.leaf, size: 38) {
                    router.go(.worldMap)
                }

                Spacer()

                HStack {
                    ChunkyButton(title: "My Collection", icon: "star.fill", color: Theme.sunny, size: 21) {
                        router.go(.collection)
                    }
                    Spacer()
                    if !settings.meetingModeOn {
                        ChunkyButton(title: "Meeting Mode", icon: "moon.fill", color: Theme.berry, size: 21) {
                            settings.meetingModeOn = true
                            Haptics.soft()
                        }
                        Spacer()
                    }
                    ChunkyButton(title: "Parents", icon: "person.fill", color: Theme.sky, size: 21) {
                        router.requestGate(.openParentArea)
                    }
                }
                .padding(.horizontal, 34)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            let name = settings.cheerName
            let greeting = name.isEmpty ? "" : ", \(name)"
            audio.speakOnce("Welcome to Little Bible Helpers\(greeting)!", key: "home-welcome")
        }
    }
}
