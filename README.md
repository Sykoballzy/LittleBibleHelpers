# Little Bible Helpers

A premium, offline-first iPad app of quiet Bible-themed learning games for children ages 2–5. Landscape-only, no ads, no purchases, no accounts, no network.

**Status: Iteration 1** — architecture, navigation, and the first playable world (Noah's Ark) with four activities built on reusable game templates.

## Building (requires a Mac)

The project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) so the `.xcodeproj` is generated, never committed.

```bash
brew install xcodegen
cd LittleBibleHelpers
xcodegen generate
open LittleBibleHelpers.xcodeproj
```

Select an iPad simulator (e.g. iPad Pro 11") and run. Target: iOS 16+, iPad only, landscape only.

## What's in iteration 1

- **Navigation flow**: Home → Bible World Map → Story Hub → Activity → Celebration → Reward, driven by a single `AppRouter` (no NavigationStack — full-screen custom transitions, nothing a toddler can swipe wrong).
- **Noah's Ark world**, 4 activities on 4 reusable templates:
  - *Match the Animals* (match pairs), *All Aboard!* (drag & drop), *Count the Doves* (count), *What Happened First?* (sequencing)
- **Meeting Mode**: one tap on, parent gate off; silences all audio, keeps screen awake, shows a badge. (Pairs with iOS Guided Access for true exit protection — an app cannot block the home gesture by itself.)
- **Parent gate** (math question) and **Parent Area** (narration/sound toggles, age band 2–3 / 4–5 difficulty, progress, reset, disclaimer).
- **Collection**: earned stickers in color, locked ones as silhouettes. Completing all of a world's activities unlocks its bonus character (Noah).
- **Progress persistence**: local JSON, no accounts.

## Architecture

```
Sources/
  App/        entry point, AppRouter (screen enum + parent-gate intents), RootView
  Core/       Theme (palette/typography), SettingsStore, ProgressStore,
              AudioService (narration), Haptics, shared UI components
  Content/    ContentModels (World/Activity/GameSpec/Collectible),
              ContentLibrary (all v1 content — expansion packs append here)
  Games/      GameHost (spec → template routing, completion handling)
              + one file per reusable template
  Art/        original vector illustrations (ArtKey → view), backgrounds
  Screens/    Home, WorldMap, StoryHub, Celebration, Collection,
              ParentGate, ParentArea
```

**Expansion pack design**: all content is data (`BibleWorld` / `Activity` / `GameSpec`). A new pack = new entries in `ContentLibrary` plus any new `ArtKey` illustrations. Game code is untouched. When packs become downloadable, `ContentLibrary` becomes the registry that merges bundled + downloaded packs.

**Art pipeline**: every illustration is referenced by `ArtKey` and currently rendered as original programmatic vector art (storybook style: thick outlines, rounded shapes, big eyes). Swapping any piece for a commissioned PNG/SVG changes only `ArtView`.

**Narration**: `AudioService.speak()` currently uses the system voice (slowed, warm) as a placeholder. Recorded child-friendly narration replaces the implementation of one class; every line already lives in content definitions.

## Roadmap

1. Recorded narration + gentle sound effects (bundled audio behind `AudioService`)
2. Remaining templates: Find It, Sorting, Coloring (Apple Pencil), Dress Up, Puzzle, Build It
3. Creation and David & the Sheep worlds
4. Commissioned illustration pass replacing vector placeholders where wanted
5. App icon, launch polish, App Store assets, kids-category compliance review
6. Downloadable content packs (Memorial, conventions) via on-demand resources

## Important constraints

- All artwork, text, and audio must be **completely original**. No JW.org logos, artwork, branding, music, or character designs. The app must not imply endorsement by or affiliation with any organization.
- Kids category rules: no ads, no external links, no data collection, parent gate on grown-up areas.
