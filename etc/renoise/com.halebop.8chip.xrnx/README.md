# 8chip — Renoise Chiptune Toolbox

8 modules for chiptune composition. **Requires Renoise 3.5+**

Open via **Tools → 8chip** or the assigned keybinding.

Most important things below, for full length manual, go to [https://github.com/halebop17/8chip](https://github.com/halebop17/8chip)   
Credit to Adventure Kid for his single cycle waveforms of which some are included in 8chip.
https://www.adventurekid.se/akrt/waveforms/

---

## Tabs

Top menu is arranged as 2 rows (4 tabs per row).

### 1. Waveforms
Generates a mathematical waveform into the selected instrument's sample slot.

Waveform types: Sine (pure), Pulse (variable duty, default 25%), Square 50% (fixed), Sawtooth, Triangle, Noise, FM (two-operator).

Controls: Waveform, Frames (cycle length), Duty % (Pulse only), FM Ratio/Mod (FM only), Sample Rate, Bit Depth, Loop Mode, Preview, Generate.

---

### 2. Presets
Browse and load chip instrument presets. Sources: real NES APU recordings, Genesis YM2612 samples, bundled GB/SID chip single-cycles, or mathematical waveforms.

- **Preview** — non-destructive audition (temporary instrument is removed after playback)
- **Load Preset** — adds a new instrument slot with the selected preset
- **Load Full Kit** — adds all presets in category as separate slots (`[ch.XX]` naming for phrase routing)

---

### 3. Arp
Writes arpeggio phrases into the selected instrument. Always creates a **new phrase**.

Three modes:
- **Hardware (0A)** — `0A XY` effect, most hardware-authentic
- **Explicit** — each chord note on its own phrase line
- **Script (pattrns)** — Lua script phrase, algorithmic, live-tweakable (Renoise 3.5+)

Controls: Mode, Root Note, Chord, Octave Span (1–3), Pattern (Asc/Desc/Ping-Pong/Down-Up/Skip/Random), LPB, Length, Loop, Preview, Write Phrase.

**Live Mode** *(Script only):* Any change to Root, Chord, Pattern, Octave, LPB, or Loop instantly rewrites the current script phrase — no Write click needed. Overwrites the selected phrase rather than creating a new one. Disable before switching to a different phrase.

---

### 4. Pitch
Writes pitch effect commands into a new phrase on the selected instrument.

Presets:
- **Laser Zap** — `0U` pitch sweep up over N lines then `0C` cut (upward sweep, laser effect)
- **Kick Drop** — `0D` downward pitch sweep (pitch-drop drum)
- **Bass Glide** — `0G` portamento between two notes
- **Portamento Bass** — root/fifth pattern with continuous `0G` glide

Controls: Preset, Note/Root, Target Note (Glide only), Speed, Sweep Lines, LPB, Length, Loop, Preview, Write Phrase.

---

### 5. Drums
Percussion phrases using volume step-fades and effect commands. Works on any instrument — noise or sine work best. Always creates a **new phrase**.

Presets:
- **Kick** — volume step-fade over Decay Lines then `0C` cut
- **Snare** — `0R` retrigger burst + `0C` cut
- **Hi-Hat** — short `0C` on every line; optional `0Y` probability for shuffle feel
- **Noise Burst** — volume step-fade over Decay Lines then `0C` cut

Controls: Preset, Note, Decay Lines (Kick/Noise), Retriggers (Snare), Cut Tick (Hi-Hat), Probability % (Hi-Hat), LPB, Length, Loop, Preview, Write Phrase.

---

### 6. Mod
Injects vibrato (`0V`), tremolo (`0T`), or auto-pan (`0N`) into a phrase or pattern region.

**Target — New Phrase:** creates a new phrase, writes effects on every line, adds a sustained trigger note on line 1.  
**Target — Pattern Region:** injects effects only onto lines that already have a note — does not write or remove notes.

Controls: Quick Preset, Effect, Speed (0–15), Depth (0–15), Note, LPB, Length, Loop, Target, Preview, Write/Inject.

---

### 7. Probability
Applies `0Y` (probability) and `0Q` (delay) to notes in the **selected pattern region**. Select notes in the pattern editor first.

Tools:
- **Probability Scatter** — adds `0Y` to selected notes at a given density
- **Humanize** — scatters small `0Q` delay values for a loose, human feel
- **Fill (Every Nth)** — marks every Nth note with `0Y`

---

### 8. Single Cycles
Browse internal Adventure Kid waveforms or add your own folder.

Core actions:
- **Use Internal** — load bundled curated AKWF banks
- **Browse** — pick a custom folder (subfolders become banks)
- **Insert Single** — insert selected waveform as a looped sample
- **+ Add to Wavetable** — stage up to 4 waveforms in the queue
- **Insert as Wavetable** — insert queued waveforms and auto-spread keyzones across C0-B9

---

## Tips

- **Phrase LPB vs song LPB:** Phrases have their own LPB. High phrase LPB (32–64) = ultra-fast chip arps at any song tempo.
- **Kit routing:** Trigger the phrase-holder slot in your pattern. Use the instrument column inside the phrase to route lines to different sound slots.
- **Every Write creates a new phrase** (except Arp Live Mode). Use Undo (`Ctrl+Z`) if you write by mistake.
- **Combining Arp + Mod:** Use Mod's **Pattern Region** target to inject effects onto existing arp notes without creating a separate phrase.
- **Safe combinations:** Pitch + Mod ✓ — Arp + Pitch slide ✓ — Arp + Tremolo/Auto-Pan ✓ — **Arp + Vibrato ✗** (both modify pitch, unpredictable results).
