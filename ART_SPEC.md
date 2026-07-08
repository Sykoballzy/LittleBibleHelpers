# ART_SPEC — Little Bible Helpers asset generation guide

The complete manifest for the AI art pass. Work through it in phases; every
finished PNG goes in `Resources/` with the EXACT filename listed (case
matters), then the app uses it automatically in place of the vector
placeholder.

---

## 0. STATUS TRACKER (working doc — updated 2026-07-08, wiring shipped)

**72 of 73 sticker keys have real art — the sticker set is DONE** (only
`art_penFull` remains on its vector fallback). All 74 files PASS the
transparency audit. Wired into the app and committed.

### ✅ Wired & shipped
- The full cast, all animals, all objects, jars (singles + trio stages),
  bags (all 3 states), cleaning tools, the fixed hall.
- `bird` key renamed (was dove) → uses `art_bird.png`.
- Child feature: Parent Area sets name + Boy/Girl; the `child` key renders
  `art_malechild.png` / `art_femalechild.png`; narration cheers by name.

### ✏️ Stickers to make (playtest round, 2026-07-08)
- [ ] `art_penFull.png` — edit `art_pen`, add two sheep peeking over the
      rail. (Vector fallback covers it meanwhile.)
- [ ] `art_bird.png` — NEW: a generic cheerful little songbird (bluebird or
      sparrow style), NO olive branch. The dove art is now `art_dove.png`
      and stays Noah/Peace-specific; this bird covers creation/sky contexts.
- [ ] `art_speaker.png` — NEW: modern-day meeting speaker — friendly man in
      a suit and tie, holding a Bible, warm smile. (Meetings world is
      MODERN dress, unlike the Bible-account worlds.)
- [ ] `art_hallWindow.png` — NEW: modern meeting-hall window — clean
      rectangular white/cream frame, four bright panes, simple sill.
      (Daniel keeps the arched stone night window; this one is for
      Clean the Hall.)
- [ ] (idea, optional) modern-dress congregation friends
      (`art_friendA/B/C`) — would let all of Meetings world read modern-day
      instead of reusing the robed Bible villagers. Wire-up needed after
      generation, so tell Claude when these exist.

### 🔎 Optional polish (only if it bugs you on device)
- [ ] `art_bigFish.png` — chubby fish, not whale-shaped. Doctrinally fine.
- [ ] `art_angel.png` — correct (no wings/halo) but a bit Jesus-adjacent.

### 🗺️ Not started — later phases (the next generation sessions)
- [ ] 8 backgrounds `bg_*` (Phase 3) — biggest world-variety win; keep
      opaque, do NOT background-remove
- [ ] 5 coloring pages `coloring_*` (Phase 4) — white line-art, no bg removal
- [ ] 12 apostles `art_apostle_01..12` (Phase 5) — unlocks face-match game
- [ ] App icon (1024×1024, opaque) — required for TestFlight

---

## 1. Global rules (every image)

- **Format:** PNG, true transparent background (verify — not a white square).
- **Size:** 1024×1024 for all `art_*` stickers; 2048×1536 for `bg_*`
  backgrounds; 2048×1434 for `coloring_*` pages.
- **Framing:** one subject, centered, ~8% empty padding on all sides,
  front-facing "sticker" pose.
- **No text, letters, numbers, logos, watermarks, or signatures.**
- Consistent light source (soft, from upper left). No hard drop shadows.
- Must read clearly at 80 px — bold silhouette, no fussy detail.
- **NO white die-cut "sticker" border** — the dark outlines must meet the
  transparent background directly. (The word "sticker" in a prompt sometimes
  triggers a literal white border; if it appears, edit it off.)

### ⚠️ Gotchas we hit (read before generating)

1. **Fake transparency is the #1 trap.** Many tools export the gray-and-white
   checkerboard BAKED INTO the pixels — it looks transparent in every preview
   but is a solid opaque square in the file. **Always download/export the
   REAL original PNG**, not a preview screenshot. If unsure, background-remove
   it (Adobe Express etc.) or ask Claude to run the alpha audit. Backgrounds
   (`bg_*`) and coloring pages (`coloring_*`) are the exceptions — those are
   SUPPOSED to be opaque; don't bg-remove them.
2. **Objects trigger "product photo" mode** — models add a white background
   and a floor drop-shadow to props (planks, tools, jars). Add
   *"fully transparent background, no drop shadow"* explicitly to object
   prompts.
3. **Buildings/scenes trigger "architectural render" mode** — realistic
   perspective, window reflections, muted palette. Force cartoon with:
   *"simple flat cartoon shapes, thick dark outlines, flat cel shading,
   NOT realistic, NOT an architectural rendering, no window reflections."*
4. **Scale can't be done with adjectives.** "Huge"/"giant" mean nothing on a
   blank canvas, and negatives ("not a whale") backfire. Convey size through
   ANATOMY and in-frame anchors: *"proportionally tiny eye, small fins that
   look tiny against its giant body, mouth big enough to swallow a boat."*
   Describe the shape you WANT positively ("shaped like a friendly whale").

### Master style block (paste at the start of every prompt)

> Children's storybook illustration sticker for a preschool app, cute
> cartoon style, thick clean dark-brown outlines, soft cel shading, bright
> cheerful but calming colors, rounded friendly shapes, large expressive
> eyes with white highlights, rosy blush cheeks, warm and gentle mood,
> isolated on a transparent background, centered, no text, high quality
> vector-like finish.

### Doctrinal art rules (hard constraints — check every image)

- NO crosses, halos, or religious symbols of any kind.
- Angel: glowing humanlike figure, warm light — **no halo, no wings**.
- Jesus: kind bearded man in a simple robe — no halo, no glow, no symbols.
- The fruit is a **generic golden fruit** — must NOT read as an apple.
- Serpent: clearly a snake, sly but never scary or gory.
- Modest robes on all characters; nothing frightening anywhere.

### Character consistency (the "reusable cast" method)

Generate all people in ONE style session: describe every character with the
same body formula — *big round head, small simple body, same proportions* —
and vary only: skin tone, hair (color/length), beard (none/short/long/white),
robe color, one accessory. When your tool supports it, reuse the seed /
"consistent character" mode from the first good result. Generate 2–4
candidates per asset and keep the one that best matches the cast.

---

## 2. Phase 1 — The Cast (people + hero animals). Biggest visual impact.

| Filename | Subject |
|---|---|
| `art_noah.png` | elderly kind man, long white hair + full white beard, brown robe, tan sash |
| `art_adam.png` | young man, short dark brown hair, no beard, leaf-green tunic |
| `art_david.png` | boy shepherd, reddish-brown hair, golden-yellow tunic, wooden staff at side |
| `art_daniel.png` | adult man, short black hair + short beard, purple robe with gold sash |
| `art_jonah.png` | adult man, brown hair + short beard, teal robe |
| `art_jesus.png` | kind man, shoulder-length brown hair + short beard, cream robe with coral sash (NO halo/symbols) |
| `art_angel.png` | glowing humanlike messenger, golden-blond hair, white robe, soft warm radiance (NO wings, NO halo) |
| `art_child.png` | happy toddler, brown hair with a tuft, sky-blue tunic |
| `art_people.png` | Adam and Eve side by side: him green tunic short dark hair, her golden tunic long auburn hair |
| `art_villagerA.png` | townsperson, black hair, sky-blue robe |
| `art_villagerB.png` | townsperson, brown hair, coral robe |
| `art_villagerC.png` | townsperson, dark-brown hair, purple robe |
| `art_lion.png` | friendly lion, bumpy orange mane, big smile |
| `art_elephant.png` | friendly gray-blue elephant, pink inner ears, trunk down |
| `art_giraffe.png` | friendly giraffe head+neck, orange spots, little ossicones |
| `art_sheep.png` | fluffy cloud-wool sheep, tan face, sweet smile |
| `art_dove.png` | white dove in gentle flight holding a tiny olive sprig |
| `art_fish.png` | small cheerful blue fish with light belly, bubbles |
| `art_bigFish.png` | huge gentle blue-gray fish, calm kind eye (the great fish, not a whale) |
| `art_serpent.png` | coiled green snake, narrow sly eyes, forked tongue — sneaky, not scary |

## 3. Phase 2 — Story objects & tools

| Filename | Subject |
|---|---|
| `art_ark.png` | big wooden ark: hull + little cabin with round window |
| `art_arkPlanks.png` | neat stack of wooden planks |
| `art_arkFrame.png` | wooden skeleton frame of the ark hull |
| `art_arkHull.png` | finished plain wooden hull (no cabin, unpainted) |
| `art_boat.png` | small wooden sailboat, cream sail |
| `art_rainbow.png` | bright arched rainbow with small clouds at each end |
| `art_stormCloud.png` | soft gray rain cloud with falling drops (not angry) |
| `art_sun.png` | smiling golden sun with rounded rays |
| `art_moon.png` | sleepy crescent-ish yellow moon with craters |
| `art_star.png` | golden five-point star with a tiny smile |
| `art_earth.png` | smiling planet earth, green continents |
| `art_tree.png` | round leafy fruit tree with small golden fruits |
| `art_heart.png` | glossy warm red-coral heart |
| `art_hall.png` | small friendly single-story meeting hall, warm cream walls, coral roof (generic, welcoming) |
| `art_saw.png` | hand saw, wooden handle |
| `art_hammer.png` | claw hammer, wooden handle |
| `art_brush.png` | paintbrush with coral paint on the bristles |
| `art_scroll.png` | open parchment scroll showing a tiny picture of rain over an ark (picture only, no writing) |
| `art_soil.png` | small mound of brown soil with pebbles |
| `art_seed.png` | large teardrop seed with a tiny green leaf |
| `art_sprout.png` | tiny green sprout with two leaves in a soil mound |
| `art_sapling.png` | young leafy sapling in a soil mound |
| `art_wateringCan.png` | sky-blue watering can with water drops from the spout |
| `art_fruit.png` | generic golden oval fruit with two leaves (NOT an apple) |
| `art_basket.png` | woven tan basket with an arched handle |
| `art_sling.png` | shepherd's sling: leather pouch on two cords with a smooth stone |
| `art_harp.png` | small golden lyre-style harp with strings |
| `art_staff.png` | wooden shepherd's staff with curved crook |
| `art_bucket.png` | wooden water pail with rope handle, water visible |
| `art_stone.png` | one smooth gray river stone |
| `art_penFrame.png` | two wooden fence posts with one rail (a pen being built) |
| `art_pen.png` | finished small wooden sheep-pen fence |
| `art_penFull.png` | same pen with two happy sheep peeking over the rail |
| `art_crown.png` | golden three-point crown with colorful gems |
| `art_window.png` | arched open window with night sky, crescent moon and stars inside |
| `art_bread.png` | round golden loaf of bread, scored top |
| `art_bag.png` | teal fabric shoulder bag with a button flap |
| `art_bagWithBook.png` | same teal bag with a brown book peeking out |
| `art_bagPacked.png` | same teal bag with brown book + coral songbook peeking out, tiny star patch |
| `art_book.png` | warm brown book with a small golden heart on the cover (generic — NOT any real edition) |
| `art_songbook.png` | coral songbook with a white music note on the cover |
| `art_chair.png` | simple padded stacking chair, blue-gray |
| `art_cloth.png` | folded light-blue cleaning cloth with soap bubbles |
| `art_broom.png` | wooden broom with straw bristles |
| `art_spray.png` | teal spray bottle with a fine mist |
| `art_jar.png` | large clay water jar (amphora) with two handles, empty |
| `art_jarWater.png` | SAME jar with clear water at the rim |
| `art_jarWine.png` | SAME jar with deep red wine at the rim, tiny sparkle |
| `art_jars0.png` | THREE clay jars in a row, all empty |
| `art_jars1.png` | same three jars, first one filled with water |
| `art_jars2.png` | same three jars, two filled with water |
| `art_jars3.png` | same three jars, all filled with water |
| `art_jarsWine.png` | same three jars, all deep-red wine, golden sparkles above |

**State sets (`jar*`, `jars*`, `bag*`, `pen*`, `ark*`):** generate the BASE
image first, then create the variants by EDITING/inpainting that same image
so only the contents change. The stages must look like the same object.

## 4. Phase 3 — Backgrounds (2048×1536, full-bleed, NO transparency)

Soft, uncluttered, low-contrast — game pieces must stay readable on top.
Keep the middle third calm; detail at the edges.

| Filename | Scene |
|---|---|
| `bg_creation.png` | lush garden: soft green meadow, flowering trees, distant waterfall |
| `bg_noah.png` | rolling meadow with the wooden ark on a hill, big sky |
| `bg_david.png` | golden-hour pasture with soft hills and a distant sheepfold |
| `bg_jonah.png` | gentle sea: soft waves, distant ship, big sky |
| `bg_daniel.png` | warm palace interior at evening: columns, arched night window |
| `bg_jesus.png` | Sea of Galilee shore: calm water, soft hills, morning light |
| `bg_meetings.png` | bright friendly hall interior: rows of chairs, warm light, plants |
| `bg_qualities.png` | orchard of fruit trees in soft sunshine |

(Wired per-world after assets arrive — one small code change total.)

## 5. Phase 4 — Coloring pages (2048×1434, WHITE background)

Pure black-and-white line art, coloring-book style: very thick smooth
outlines, LARGE fully-closed regions (a toddler taps them), 5–8 regions per
page, no shading, no gray, no tiny gaps.

| Filename | Scene |
|---|---|
| `coloring_rainbow.png` | big arched rainbow (6 bands) over grass, sun in the corner |
| `coloring_garden.png` | fruit tree, flowers, sun — the garden |
| `coloring_morning.png` | sunrise over hills (Daniel's happy morning) |
| `coloring_joy.png` | balloons, sun, and grass |
| `coloring_ark.png` | the ark on water with a dove (future page) |

After each page: tell Claude which color belongs in which region — the tap
zones get mapped in code to match the picture.

## 6. Phase 5 — The Twelve (needs the cast method working well)

`art_apostle_01.png` … `art_apostle_12.png` — twelve distinct friendly men,
same body formula, each unique via hair/beard/robe-color combos. Unlocks the
face-matching "Name the Apostles."

## 7. Workflow

1. Generate with the master style block + the subject line from the table.
2. Check the doctrinal rules + QA: transparent bg, consistent outlines,
   reads at 80 px, no text.
3. Save into `Resources/` with the exact filename.
4. Tell Claude → commit + push → next Mac session shows the new art.
   (First asset batch only: the Xcode project needs one `xcodegen generate`.)

Priority if time is short: Phase 1 cast → `art_ark` + `art_rainbow` +
`art_hall` → backgrounds → everything else.
