import SwiftUI

struct ParentAreaView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var progress: ProgressStore

    @State private var showResetConfirm = false

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                        router.go(.home)
                    }
                    Spacer()
                    Text("Parent Area")
                        .font(Theme.title(34))
                        .foregroundColor(Theme.textDark)
                    Spacer()
                    Color.clear.frame(width: 64, height: 64)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        settingsCard
                        progressCard
                        aboutCard
                    }
                    .padding(24)
                    .frame(maxWidth: 760)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .alert("Reset all progress?", isPresented: $showResetConfirm) {
            Button("Reset", role: .destructive) { progress.resetAll() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Completed activities and the sticker collection will start over.")
        }
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            sectionTitle("Settings")

            Toggle(isOn: $settings.narrationEnabled) {
                Text("Narration").font(Theme.body(20)).foregroundColor(Theme.textDark)
            }
            .tint(Theme.leaf)

            Toggle(isOn: $settings.soundEffectsEnabled) {
                Text("Sound effects").font(Theme.body(20)).foregroundColor(Theme.textDark)
            }
            .tint(Theme.leaf)

            Toggle(isOn: $settings.meetingModeOn) {
                Text("Meeting Mode").font(Theme.body(20)).foregroundColor(Theme.textDark)
            }
            .tint(Theme.berry)

            Text("Meeting Mode silences all narration and sounds, keeps the screen awake, and requires the grown-up question to turn off. For full protection against your child leaving the app, also turn on Guided Access (Settings → Accessibility → Guided Access) and triple-click the top button when handing over the iPad.")
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Theme.textDark.opacity(0.6))

            sectionTitle("Child's age")

            HStack(spacing: 12) {
                ForEach(AgeBand.allCases) { band in
                    Button {
                        settings.ageBand = band
                    } label: {
                        Text(band.label)
                            .font(Theme.body(18))
                            .foregroundColor(settings.ageBand == band ? .white : Theme.textDark)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(settings.ageBand == band ? Theme.leaf : Theme.creamDeep)
                            )
                    }
                    .buttonStyle(SquishyButtonStyle())
                }
            }

            Text("The age setting adjusts difficulty — how many pairs to match, how high to count.")
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Theme.textDark.opacity(0.6))
        }
        .softCard()
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Progress")

            ForEach(ContentLibrary.worlds.filter(\.isAvailable)) { world in
                HStack {
                    Text(world.title)
                        .font(Theme.body(19))
                        .foregroundColor(Theme.textDark)
                    Spacer()
                    Text("\(progress.completedCount(in: world)) of \(world.activities.count) activities")
                        .font(Theme.body(17))
                        .foregroundColor(Theme.textDark.opacity(0.6))
                }
            }

            Button {
                showResetConfirm = true
            } label: {
                Text("Reset progress")
                    .font(Theme.body(17))
                    .foregroundColor(Theme.coral)
            }
            .padding(.top, 4)
        }
        .softCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("About")

            Text("Little Bible Helpers is an independent educational app created for families. It is not produced or endorsed by, or affiliated with, any religious organization. All artwork, narration, and content are original.")
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Theme.textDark.opacity(0.65))

            Text("Offline · No ads · No purchases · No accounts · No data collection")
                .font(Theme.body(15))
                .foregroundColor(Theme.leaf)

            Text("Version 0.1 — Noah's Ark preview")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Theme.textDark.opacity(0.45))
        }
        .softCard()
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(Theme.body(23))
            .foregroundColor(Theme.textDark)
    }
}
