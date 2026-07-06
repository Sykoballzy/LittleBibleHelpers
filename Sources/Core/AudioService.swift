import AVFoundation
import SwiftUI

/// Narration + (future) sound effects. Silent by default in Meeting Mode.
/// Narration currently uses the system voice as a placeholder; when recorded
/// narration is produced, only this class changes — call sites stay the same.
final class AudioService: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private let settings: SettingsStore
    private var spokenOnce = Set<String>()

    init(settings: SettingsStore) {
        self.settings = settings
        // .ambient: respects the mute switch and never interrupts other audio.
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func speak(_ line: String) {
        guard settings.narrationEnabled, !settings.meetingModeOn, !line.isEmpty else { return }
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: line)
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.12
        utterance.voice = Self.narrationVoice
        synthesizer.speak(utterance)
    }

    /// Speaks a line at most once per app session (welcome lines, hints).
    func speakOnce(_ line: String, key: String) {
        guard !spokenOnce.contains(key) else { return }
        spokenOnce.insert(key)
        speak(line)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    private static let narrationVoice: AVSpeechSynthesisVoice? = {
        let english = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("en") }
        return english.first { $0.quality == .enhanced } ?? AVSpeechSynthesisVoice(language: "en-US")
    }()
}
