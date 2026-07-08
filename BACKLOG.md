# Backlog — Little Bible Helpers

Ideas captured but not yet built. Ordered roughly by priority.

## 1. The Art Pass (next major initiative — approved direction)

Replace programmatic vector placeholders with AI-generated, reusable,
consistent assets. Committed direction (Travis, iter 12): not hiring an
illustrator; generate impactful reusable assets instead.

- **Component character system** ("South Park model"): one reusable body rig
  with swappable features — skin tones, hair, beards, robes, expressions —
  so every Bible character and villager comes from the same kit and stays
  consistent across worlds. Unlocks: 12 distinct apostle faces, named
  characters, richer Deliver/Pathway scenes.
- **Coloring-book pages for Tap-to-Color**: white line-art scenes (thick
  black outlines, big closed regions), one PNG per page + a region map
  (tap zones as data over the image). Fixes the template's quality ceiling.
- **Per-world backgrounds**: sea for Jonah, night palace for Daniel, hall
  interior for Meetings, garden for Creation (all worlds share the meadow
  today).
- **Scene props**: real floor/dust art for Clean Up's sweep task, aisle/chair
  rows for Meet the Speaker, den walls for Daniel.
- Pipeline: Travis generates from a written asset spec (exact filenames,
  sizes, transparent backgrounds, style prompt); assets go in a Resources/
  folder; project.yml gains a resources entry (one-time regenerate); art
  keys switch from vector views to images asset-by-asset.

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
