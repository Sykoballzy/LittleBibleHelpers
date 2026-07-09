# Backlog — Little Bible Helpers

Ideas captured but not yet built. Ordered roughly by priority.

## 0. Platform strategy — Android is REQUIRED (Travis, 2026-07-08)

- Android must ship, fairly high priority. The current app is native SwiftUI,
  so "porting" = rebuilding the engine in a cross-platform framework.
- Working recommendation: **Flutter rewrite as the v1.0 engine** once games
  are validated on a real iPad — one codebase for iOS + Android, excellent
  for custom-drawn kids' games. The SwiftUI app is the validated prototype/
  spec; ALL art-pass PNGs, content data, narration scripts, and game designs
  transfer directly.
- Decision gate: BEFORE building StoreKit or recording narration (both are
  platform-specific spends). Art pass is platform-neutral — do it now.
- A Mac is still required regardless (iOS builds/signing even in Flutter).
  Travis is shopping: new low-end M4 Mac mini (or Apple Certified Refurbished)
  over the used market.

## 1. The Art Pass (IN PROGRESS — spec shipped 2026-07-08)

- `ART_SPEC.md` written: 73-asset manifest, master style prompt, doctrinal
  art rules, consistency method, phases (cast → objects → backgrounds →
  coloring pages → the Twelve).
- App wiring DONE: any `Resources/art_<key>.png` automatically replaces its
  vector placeholder (ArtView image override); project.yml includes optional
  Resources folder.
- Travis generates assets into `Resources/`; Claude commits + maps coloring
  regions and backgrounds as they arrive.

Goals (from Travis's "South Park" reusable-asset direction): component
character system (one body formula, swappable features — unlocks 12 apostle
faces), coloring-book pages for Tap-to-Color, per-world backgrounds, and
scene props (dust piles, aisle rows, den walls). Details in ART_SPEC.md.

## 2. Big Kids band (ages 6–7) — approved direction

- Third `AgeBand` case with harder parameters on existing templates: counts
  to 20, more pairs, longer sequences, bigger give-N numbers.
- Interactive family-worship features for readers: find-the-verse games,
  scripture matching (citation-pill infrastructure exists), word/picture
  matching.
- "Name the Apostles" face-matching version (needs the character system
  from the art pass: 12 distinct portraits).

## 3. Game templates still to build

- Dress Up (get David ready; prepare for the meeting).
- Jigsaw Puzzle (6–12 big pieces).
- Built already: Match, Board, Count(-by-type/labels), Sequence, Sort,
  Action Sequence(+reps), Find It, Shadow Match, Deliver, Gather,
  Give Number(+decoys), Tap-to-Color, Pathway, Clean Up — 14 templates.

## 3.5 Monetization model (decided in principle, Travis 2026-07-08)

- **Free tier:** the first two worlds (Creation + Noah — 16 full games).
  Generous by design: trust and word-of-mouth are the growth engine.
- **Base unlock: $9.99 one-time → the remaining EIGHT worlds** (~65
  activities). (Updated 2026-07-08 after the app grew to 10 worlds — fixes
  the old value-ladder asymmetry: base is the big box, packs are add-ons.)
- **Expansion packs:** $4.99 each, one-time, non-consumable, offline forever.
- **Fully loaded target:** ~$30 (base + ~4 packs). No ads, no subscriptions,
  ever. Enable Family Sharing on all IAPs (big families!).
- Purchases live behind the parent gate (Kids Category requirement — the
  gate already exists).

## 3.6 Convention packs — "learn along with the talks" (Travis 2026-07-08)

Yearly $4.99 pack timed to the regional convention season. A preschooler's
companion to the convention weekend:

- Pack-your-convention-bag (transform), find-your-seat (pathway),
  quiet listen-along activities for sessions, walk-don't-run reminders.
- A coloring page per convention day; session/day badges to collect.
- Games built on the year's THEME SCRIPTURE (scripture text itself, not
  program materials).
- HARD GUARDRAILS: never reproduce program content, talk outlines, official
  theme artwork, logos, or songs. All activities and art 100% original,
  themed around convention-day life and the public scripture only.
- Pipeline note: pack must ship BEFORE convention season each year —
  recurring annual content without a subscription.

## 4. Content expansion (pack roadmap)

- **Jesus packs** (Travis): Jesus' Miracles, Jesus' Ministry, the Ransom's
  benefit (Memorial pack), the Resurrection.
- **Memorial pack**: Deliver template ready for "pass the bread"-style
  activities; respectful preparation/etiquette games.
- **Convention packs** (yearly): pack the bag, find your seat, badge
  collectibles, theme coloring pages.
- More character worlds: dozens of candidates (Moses, Joseph, Ruth, Esther,
  Samuel, Josiah — young-person accounts especially).
- Broader David accounts (harp for Saul, King David) — toddler-gentle only;
  adult accounts (e.g. Bathsheba) stay out.
- Seed-promise (Genesis 3:15) dedicated activity once art depth allows.

## 5. Audio (deferred)

- Recorded warm narration replacing the system TTS voice (only
  `AudioService` changes; every line lives in content already).
- Gentle sound effects, silent in Meeting Mode.
- NWT-alignment review of all narration lines (caught one: "Peace, be
  still" is KJV; NWT Mark 4:39 is "Hush! Be quiet!" — fixed iter 12).

## 6. Ship-readiness (not started)

- App icon + launch screen.
- StoreKit: free base + one-time offline content-pack purchases (no ads,
  no subscriptions — decided).
- Apple Developer account ($99/yr), TestFlight to a real iPad (drag feel,
  audio, and performance can't be judged in the VM).
- Kids Category compliance review; privacy label (no data collected).
- Translations into major languages (post-launch).

## Known follow-ups (small)

- Sort & Classify: sea/sky use duplicate art; add creatures when art grows.
- 2-bin sort variant for the 2–3 band.
- Deliver: varied recipient reactions (wave, nod) when animation budget grows.
- Story Hub: revisit card layout if any world exceeds 9 activities.
- Clean Up sweep task: real dust-pile/floor art (art pass).
