import SwiftUI

/// "My Collection" — earned stickers in color, locked ones as soft silhouettes.
struct CollectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        ZStack {
            MeadowBackground()

            VStack(spacing: 16) {
                HStack {
                    RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                        router.go(.home)
                    }
                    Spacer()
                    BannerTitle(text: "My Collection", color: Theme.sunny)
                    Spacer()
                    Color.clear.frame(width: 64, height: 64)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 22), count: 5),
                              spacing: 22) {
                        ForEach(ContentLibrary.allCollectibles) { collectible in
                            CollectibleCard(collectible: collectible,
                                            unlocked: progress.isUnlocked(collectible.id))
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 28)
                }
            }
        }
        .onAppear {
            audio.speakOnce("Look at all your friends!", key: "collection")
        }
    }
}

struct CollectibleCard: View {
    let collectible: Collectible
    let unlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(Theme.cream)
                ArtView(key: collectible.art)
                    .padding(14)
                    .grayscale(unlocked ? 0 : 1)
                    .opacity(unlocked ? 1 : 0.25)
            }
            .frame(height: 126)

            Text(unlocked ? collectible.name : "?")
                .font(Theme.body(18))
                .foregroundColor(Theme.textDark.opacity(unlocked ? 1 : 0.5))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(unlocked ? 0.94 : 0.55))
                .shadow(color: .black.opacity(unlocked ? 0.08 : 0.03), radius: 6, y: 4)
        )
    }
}
