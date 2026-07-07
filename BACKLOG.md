# Backlog — Little Bible Helpers

Ideas captured but not yet built. Ordered roughly by priority.

## Big Kids band (ages 6–7) — approved direction (Travis, iter 10)

- Third `AgeBand` case with harder parameters on existing templates: counts to
  20, more match pairs, longer sequences, bigger give-N numbers.
- Interactive family-worship features for readers: find-the-verse games,
  scripture matching (the citation-pill infrastructure already exists),
  simple word/picture matching.
- Needs its own iteration — parameter plumbing is easy, the reading-level
  content design is the real work.

## Game templates to build

- ~~Give the Right Number~~ — DONE (iteration 8): `giveNumber` template, used
  for Daniel's 3 prayers, Jonah's 3 nights, the 2 fish, chairs, sharing.
- **Build a Pathway** — lay road tiles (straight / corner pieces) to guide a
  character along a path, collecting stars. Spatial/puzzle. Higher complexity —
  needs a tile grid and path-validation. *(Requested by Travis, iteration 4.)*
- **Tap-to-Color** — toddler coloring with no brush and no free-draw: tap a
  region, tap a color, the region fills. The palette shows ONLY the colors that
  belong in that picture, so the result always looks right and there is no
  failure state or mess. Big regions, thick outlines. *(Travis's reframe of the
  original "Coloring" idea — better for little hands than Apple Pencil.)*
- Remaining brief templates: Dress Up, Jigsaw Puzzle. (Find the Missing Item is
  covered by Find It; free-draw Coloring is superseded by Tap-to-Color above.)

## Content

- ~~Six remaining worlds~~ — DONE (iter 8). ~~Fit pass / de-dupe~~ — DONE
  (iter 9): worlds renamed (Noah, David, ...), zero within-world template
  repeats, Qualities = one game per fruitage.
- **Future Jesus packs** (Travis, iter 9): Jesus could be many worlds —
  Jesus' Miracles, Jesus' Ministry, the Ransom's benefit (Memorial pack),
  the Resurrection. Dozens of other Bible characters are pack candidates.
- Broader David accounts now in scope after rename (harp for Saul, King
  David). Keep it toddler-gentle; Goliath only as bravery/preparation
  (Five Smooth Stones); adult accounts (e.g. Bathsheba) stay out.
- Depth pass after playtest: more animation per game, richer per-world
  backgrounds (sea for Jonah, night palace for Daniel, hall interior for
  Meetings) — currently all worlds share the meadow background.
- Memorial pack and Convention packs (the Deliver template is ready for
  "pass the bread"-style activities).
- Seed-promise (Genesis 3:15) dedicated activity once art depth allows.

## Art & audio (deferred by decision, 2026-07-06)

- Tap-to-Color pages: current pages are simple vector regions. Travis wants
  proper coloring-book line art (AI-generated or commissioned) mapped to
  tappable regions — richer scenes, more regions. Part of the art pass.

- Commission or generate a cohesive premium illustration set to replace the
  programmatic-vector placeholders. Deferred until game design is locked so we
  don't pay to illustrate scenes that may change.
- Record warm child-friendly narration to replace the placeholder system voice
  (only `AudioService` changes; every line already lives in content).
- Gentle sound effects behind `AudioService`, silent in Meeting Mode.

## Known follow-ups

- Sort & Classify: sea/sky use duplicate art (only one fish / one bird asset
  today). Add more sea/sky creatures when art expands.
- Consider a 2-bin variant of Sort for the youngest (2–3) age band.
- Gather template: tree/garden scenery is currently baked into the template.
  Generalize the backdrop when a second gather-style activity is built.
- Deliver template: recipients react by wandering off; consider varied
  reactions (wave, shake head) once the animation budget grows.
- Story Hub uses 3 columns at 7+ activities; revisit card layout if any world
  exceeds 9.
