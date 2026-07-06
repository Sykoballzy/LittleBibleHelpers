import SwiftUI

struct WorldMapView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        ZStack {
            MeadowBackground()

            VStack(spacing: 12) {
                HStack {
                    RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                        router.go(.home)
                    }
                    Spacer()
                    BannerTitle(text: "Choose a Bible Story", color: Theme.berry)
                    Spacer()
                    Color.clear.frame(width: 64, height: 64)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 26) {
                        ForEach(ContentLibrary.worlds) { world in
                            WorldCard(world: world,
                                      completed: progress.completedCount(in: world)) {
                                if world.isAvailable {
                                    router.go(.storyHub(worldID: world.id))
                                } else {
                                    Haptics.soft()
                                    audio.speak("\(world.title) is coming soon!")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 34)
                    .padding(.vertical, 22)
                }

                Spacer()
            }
        }
        .onAppear {
            audio.speakOnce("Which Bible story would you like to visit?", key: "world-map")
        }
    }
}

struct WorldCard: View {
    let world: BibleWorld
    let completed: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 14) {
                ZStack {
                    Circle().fill(world.accent.opacity(0.18))
                    ArtView(key: world.icon).padding(16)
                }
                .frame(width: 168, height: 168)

                Text(world.title)
                    .font(Theme.body(23))
                    .foregroundColor(Theme.textDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)

                if world.isAvailable {
                    HStack(spacing: 6) {
                        StarShape()
                            .fill(completed > 0 ? Theme.sunny : Theme.creamDeep)
                            .frame(width: 20, height: 20)
                        Text("\(completed) of \(world.activities.count) played")
                            .font(Theme.body(16))
                            .foregroundColor(Theme.textDark.opacity(0.6))
                    }
                } else {
                    Text("Coming Soon")
                        .font(Theme.body(16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(Theme.textDark.opacity(0.45)))
                }
            }
            .padding(22)
            .frame(width: 252, height: 328)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.10), radius: 9, y: 6)
            )
            .saturation(world.isAvailable ? 1 : 0.25)
            .opacity(world.isAvailable ? 1 : 0.82)
        }
        .buttonStyle(SquishyButtonStyle())
    }
}
