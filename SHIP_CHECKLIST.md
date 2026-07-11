# SHIP CHECKLIST — Little Bible Helpers → iOS

Working doc. The path is: **finish assets → Mac + accounts → TestFlight beta
→ platform decision → StoreKit → App Store.** TestFlight needs NO in-app
purchases, so the beta comes well before the monetization build.

---

## 1. Asset completion (Travis — generation sessions)

- [x] **Backgrounds ×10** (DONE 2026-07-10 — all ten live in the app) —
      creation, noah, david, jonah, daniel, jesus, meetings, ministry,
      activities, qualities.
- [x] **Coloring pages ×5** (DONE — rainbow, garden, morning, joy + ark,
      all wired w/ pixel-measured seed maps).
- [ ] Remake queue from 2026-07-10 playtest — see ART_SPEC.md: winged
      angel, plain scroll, magazine (new), simpler window, modern
      classmates, 12 distinct apostles.
- [x] **App icon** (DONE 2026-07-08 — wired into Assets.xcassets) — 1024×1024, OPAQUE. Reads at
      60px. Child-forward direction (see ART_SPEC): toddler girl hugging the
      heart-cover Bible, sunburst corner (no halo effect), playful tilt.

## 2. Hardware & accounts (Travis)

- [ ] **Mac** (shopping: used M1 MacBook ~$500, prefer 16GB; or M4 mini $599).
- [ ] **Apple Developer Program** — $99/yr, developer.apple.com. Needed for
      TestFlight + App Store. Enroll as individual (fastest) — note the
      seller name shown on the store will be your personal name unless you
      form an LLC (a later, optional decision).
- [ ] Verify app NAME availability in App Store Connect early ("Little Bible
      Helpers"). Keywords must avoid "JW"/org terms (no implied affiliation).

## 3. Code work before TestFlight (Claude, from Windows)

- [x] **PNG optimization pass** (DONE - tools/Optimize-Art.ps1, rerun per drop) — 80+ stickers at ~1.2MB each ≈ 100MB+
      bundle. Downscale to ~512px + recompress → target under ~25MB.
      (Claude runs it; originals archived first.)
- [x] **App icon wiring** (DONE) — asset catalog + project.yml when the icon PNG
      exists (one regenerate).
- [x] **Narration text audit** (DONE 2026-07-08: 49 corrections applied) — NARRATION_REVIEW.md (generated) — Travis
      reads every line once for NWT alignment / tone; Claude fixes flags.
- [x] Coloring-page wiring (DONE — all five pages live, wand is now a
      tap-tool that fills the tapped region with its right color).
- [ ] Final content sweep: every activity playable, rewards unique, no
      vector placeholders left where PNGs exist.

## 4. TestFlight beta (together, first Mac session after account)

- [ ] Xcode: set Team + bundle ID signing (one-time).
- [ ] Archive → upload to App Store Connect → TestFlight internal testing.
- [ ] Install on the family iPads. THE FIRST REAL-DEVICE CHECKS:
      - [ ] **Audio** (narration has never been heard on any device!)
      - [ ] Touch feel of every drag game (VM mouse ≠ toddler fingers)
      - [ ] Meeting Mode + Guided Access together at an actual meeting
      - [ ] Performance/launch time with full art
      - [ ] Scarlet full playthrough: watch, take notes, iterate
- [ ] Beta with a few friendly families (TestFlight external, up to 10k).

## 5. Platform gate (decision, before public launch)

- [ ] DECIDE: native iOS ship now + Flutter rewrite later for Android, or
      Flutter rewrite first (one codebase both stores). See BACKLOG #0.
      Everything above transfers either way (art, content, designs, audio).

## 6. Store build (after platform decision)

- [ ] StoreKit: free (Creation+Noah) + $9.99 base unlock (8 worlds) +
      $4.99 packs,
      Family Sharing on, purchases behind the parent gate.
- [ ] Restore-purchases button in Parent Area (App Store requirement).
- [ ] Content gating UI: locked worlds visible on the Journey with a
      friendly padlock + parent-gated purchase flow.

## 7. App Store submission package

- [ ] Kids Category (ages 0–5 band): parental gate ✓ built, no ads ✓,
      no data collection ✓, no external links ✓, no third-party SDKs ✓.
- [ ] Privacy policy URL (required for Kids) — simple static page:
      "collects nothing, stores progress on device." (Claude drafts;
      host free on GitHub Pages.)
- [ ] App Privacy label: "Data Not Collected."
- [ ] Age rating questionnaire (4+).
- [ ] iPad screenshots (13" and 11" classes), app description, subtitle,
      keywords — description includes the independence disclaimer
      ("not affiliated with any religious organization").
- [ ] Copyright note: scripture CITATIONS only (refs are fine); narration
      stays original paraphrase — no verse-text quotations from any
      translation beyond de minimis phrases.

## 8. Explicitly OK to ship v1 WITHOUT (post-launch roadmap)

- Recorded narration (TTS is acceptable for beta; revisit for public launch)
- Sound effects/music
- Big Kids 6–7 band, multiple child profiles
- The 12 apostles face-match game
- Translations
