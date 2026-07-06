# Little Bible Helpers — Project Rules

Read README.md for architecture. Quick orientation for every session:

## What this is
Offline iPad app (iOS 16+, landscape only, SwiftUI) of quiet Bible-learning games for ages 2–5 in Jehovah's Witness families. Premium Montessori-app polish. Development happens on Windows; building/testing requires a Mac with XcodeGen (`xcodegen generate`).

## Non-negotiable product rules
- All artwork, text, audio: completely original. Never use or imitate JW.org logos, artwork, branding, music, or character designs. Never imply endorsement or affiliation.
- Calm and gentle always: no flashing, no loud rewards, no timers, no failure states. Children always feel successful. Narration encourages, never criticizes.
- No ads, no in-app purchases (packs may come later — still no ads), no accounts, no network, no analytics.
- Everything usable by a non-reader: pictures + narration carry all meaning; text is for parents.
- Touch targets big (≥60pt for child-facing controls). SF Rounded everywhere via `Theme`.

## Code conventions
- Content is data: new games/worlds go in `ContentLibrary` as `BibleWorld`/`Activity`/`GameSpec` entries. Game templates live in `Sources/Games/`, one file each, and take a spec + `onComplete` closure.
- All art referenced by `ArtKey`, rendered in `ArtView`. New art = new key + vector view in `Sources/Art/` (120×120 design space via `ArtCanvas`, offsets from center).
- Navigation is the `Screen` enum on `AppRouter`. No NavigationStack.
- Narration lines live in content definitions, spoken via `AudioService.speak()`. Meeting Mode must silence everything.
- Grown-up destinations must go through the parent gate (`router.requestGate`).
- Persist via `ProgressStore` (JSON) and `SettingsStore` (UserDefaults) only.
