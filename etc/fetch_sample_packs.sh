#!/usr/bin/env bash

# This script depends on atool, curl and 7zz
# Changelog:
# V1.1: Now if it can't extract any reasonable name from the link, just append `|NAME.format` to the link!

set -e
# ❤️ http://freepats.zenvoid.org/
# ❤️ https://versilian-studios.com/
# ❤️ https://soundpacks.com/category/free-sound-packs/
# ❤️ https://archive.org/
# ❤️ https://sonniss.com/gameaudiogdc/
# Those are CC0 licensed or public domain or similar 👍
piano=(
  # Piano
  'http://freepats.zenvoid.org/Piano/UprightPianoKW/UprightPianoKW-small-bright-SFZ+FLAC-20190703.7z'
  'https://github.com/freepats/old-piano-FB/releases/download/2020-04-01/PianoFB-SFZ+FLAC-20200401.7z'
  # 'https://github.com/freepats/fm-piano1/releases/download/2019-09-16/FM-Piano1-SFZ+FLAC-20190916.7z'
  'https://github.com/freepats/fm-piano2/releases/download/2016-11-12/FM-Piano2-SFZ+FLAC-20161112.7z'

  # Upright Piano no. 1
  'https://versilian-studios.com/Distro/VSUpright1_SFZ.zip'
)

percussion=(
  # Chromatic Percussion
  'http://freepats.zenvoid.org/ChromaticPercussion/Glass/Glass-SFZ+FLAC-20191227.7z'
  'https://github.com/freepats/hang-D-minor/releases/download/2022-03-30/Hang-D-minor-SFZ+FLAC-20220330.7z'
  'https://github.com/freepats/tubular-bells1/releases/download/2024-11-30/TubularBells-SFZ+FLAC-20241130.7z'
  'http://freepats.zenvoid.org/ChromaticPercussion/Xylophone1/Xylophone-MediumMallets-SFZ+FLAC-20200706.tar.gz'

  # Percussion
  'https://github.com/freepats/timpani/releases/download/2024-08-10/Timpani-SFZ+FLAC-20240810.7z'
  # 'http://freepats.zenvoid.org/Percussion/SynthesizerPercussion/SynthesizerPercussion-SFZ-20220718.7z'
  'https://github.com/freepats/world-percussion/releases/download/2020-09-05/WorldPercussion-SFZ+FLAC-20200905.7z'

  'https://www.mediafire.com/?6wmk6gexd4wgv8t|Live+Percussion+Sample+Pack.zip'
  'https://www.mediafire.com/?0230qm71pt6t122|Music_2000_Sample_library_44k_WAV.zip'
  'http://oceanswift.net/files/products/Ocean_Swift_-_Sounds_Of_Life.zip'

  # Ethnic
  # 'https://github.com/freepats/bagpipe/releases/download/2026-08-06/Bagpipe-SFZ+FLAC-20260806.7z'
  'http://freepats.zenvoid.org/Ethnic/Kalimba/Kalimba-SFZ-20190723.tar.xz'
  # 'http://freepats.zenvoid.org/Ethnic/JawHarp/JawHarp-SFZ-20200606.tar.bz2'
)

organ=(
  # Organ
  'http://freepats.zenvoid.org/Organ/ChurchOrganEmulation/ChurchOrganEmulation-SFZ-20190924.tar.xz'
  'http://freepats.zenvoid.org/Organ/DrawbarOrganEmulation/DrawbarOrganEmulation-SFZ-20190712.tar.xz'
  'http://freepats.zenvoid.org/Organ/PercussiveOrganEmulation/PercussiveOrganEmulation-SFZ-20190715.tar.xz'
  'http://freepats.zenvoid.org/Organ/RockOrganEmulation/RockOrganEmulation-SFZ-20190715.tar.xz'
  'https://github.com/freepats/button-accordion-HN/releases/download/2024-03-29/ButtonAccordionHN-SFZ+FLAC-20240329.7z'
)

guitar=(
  # Guitar Family
  'http://freepats.zenvoid.org/Guitar/SpanishClassicalGuitar/SpanishClassicalGuitar-SFZ+FLAC-20190618.7z'
  'http://freepats.zenvoid.org/Guitar/FSS-SteelStringGuitar/FSS-SteelStringGuitar-SFZ-20200521.tar.xz'
  'https://github.com/freepats/ukulele1/releases/download/2026-08-11/Ukulele-SFZ+FLAC-20260811.7z'

  # Electric Guitar
  # 'https://github.com/freepats/electric-guitar-FSBS-clean/releases/download/2026-08-07/EGuitarFSBS-clean-SFZ+FLAC-20260807.7z'
  # 'https://github.com/freepats/electric-guitar-FSBS-jazz/releases/download/2026-08-07/EGuitarFSBS-jazz-SFZ+FLAC-20260807.7z'
  # 'https://github.com/freepats/electric-guitar-FSBS-direct/releases/download/2022-09-11/EGuitarFSBS-direct-SFZ+FLAC-20220911.7z'
  # 'https://github.com/freepats/electric-guitar-FSBS-dist1/releases/download/2022-09-11/EGuitarFSBS-dist1-SFZ+FLAC-20220911.7z'
  'https://github.com/freepats/electric-guitar-FSBS-dist2/releases/download/2022-09-11/EGuitarFSBS-dist2-SFZ+FLAC-20220911.7z'
  # 'https://github.com/freepats/electric-bass-YR/releases/download/2019-09-30/PickedBassYR-SFZ+FLAC-20190930.7z'
)

strings=(
  # Orchestral Strings
  'http://freepats.zenvoid.org/OrchestralStrings/ConcertHarp/ConcertHarp-SFZ+FLAC-20200702.tar.gz'

  # ETHEREALWINDS hARP ii: COMMUNITY Edition
  'https://versilian-studios.com/Distro/EWHarp2CE_SFZ-Raw.zip'
)

pipes=(
  # Reed Pipes
  'http://freepats.zenvoid.org/Reed/Clarinet1/Clarinet-SFZ-20190818.tar.xz'
  'http://freepats.zenvoid.org/Reed/TenorSaxophone/TenorSaxophone-SFZ+FLAC-20200717.tar.gz'

  # Flute Family
  'http://freepats.zenvoid.org/Wind/Recorder1/Recorder-SFZ+FLAC-20201205.7z'
  'https://github.com/freepats/ocarina1/releases/download/2024-10-02/Ocarina-SFZ+FLAC-20241002.7z'
)

synths=(
  # Synthesizer #1
  'https://github.com/freepats/lately-bass/releases/download/2024-04-09/LatelyBass-SFZ+FLAC-20240409.7z'
  'https://github.com/freepats/synth-bass-1/releases/download/2019-07-23/SynthBass1-SFZ+FLAC-20190723.7z'
  'https://github.com/freepats/synth-bass-2/releases/download/2021-04-05/SynthBass2-SFZ+FLAC-20210405.7z'
  'https://github.com/freepats/synth-strings-1/releases/download/2020-05-28/SynthStrings1-SFZ+FLAC-20200528.7z'
  'https://github.com/freepats/synth-strings-2/releases/download/2020-05-28/SynthStrings2-SFZ+FLAC-20200528.7z'
  'https://github.com/freepats/synth-brass-1/releases/download/2021-04-26/SynthBrass1-SFZ+FLAC-20210426.7z'
  'https://github.com/freepats/synth-brass-2/releases/download/2024-06-10/SynthBrass2-SFZ+FLAC-20240610.7z'

  # Synthesizer #2
  'https://github.com/freepats/synth-bass-lead/releases/download/2020-05-22/SynthBassLead-SFZ+FLAC-20200522.7z'
  'https://github.com/freepats/synth-fifths/releases/download/2020-05-19/SynthFifths-SFZ+FLAC-20200519.7z'
  'https://github.com/freepats/synth-square/releases/download/2020-05-12/SynthSquare-SFZ+FLAC-20200512.7z'
  'https://github.com/freepats/synth-calliope/releases/download/2020-05-12/SynthCalliope-SFZ+FLAC-20200512.7z'
  'https://github.com/freepats/synth-pad-choir/releases/download/2020-05-16/SynthPadChoir-SFZ+FLAC-20200516.7z'
  'https://github.com/freepats/sweep-pad/releases/download/2019-08-13/SweepPad-SFZ+FLAC-20190813.7z'
  'https://github.com/freepats/new-age/releases/download/2019-07-30/NewAge-SFZ+FLAC-20190730.7z'
  'https://github.com/freepats/synth-pad-bowed/releases/download/2019-07-19/SynthPadBowed-SFZ+FLAC-20190719.7z'
  'https://github.com/freepats/synth-goblins/releases/download/2020-06-12/SynthGoblins-SFZ+FLAC-20200612.7z'
  'https://github.com/freepats/synth-soundtrack/releases/download/20200521/SynthSoundtrack-SFZ+FLAC-20200521.7z'
  'https://github.com/freepats/synth-scifi/releases/download/2020-05-17/SynthSciFi-SFZ+FLAC-20200517.7z'
  'https://github.com/freepats/synth-crystal/releases/download/2019-08-12/SynthCrystal-SFZ+FLAC-20190812.7z'
)

sound_sets=(
  # General MIDI sound sets
  'http://freepats.zenvoid.org/SoundSets/FreePats-GeneralMIDI/FreePatsGM-SFZ+FLAC-20221026.7z'
  'http://freepats.zenvoid.org/SoundSets/GM-PercussionSet/FreePatsGM-Percussion-SFZ-20200822.tar.xz'

  # Chamber orchestra 2.1.1 Community Edition
  'https://github.com/sgossner/VSCO-2-CE/archive/refs/tags/1.1.0.zip'

  # VCSL KEys
  'https://versilian-studios.com/Distro/VCSL_Keys.zip'

  'https://www.mediafire.com/?v9ga7r6oprv0n72|G-Town+Church+Sampling+Project.zip'
)

drums=(
  'https://www.bandshed.net/sounds/AVLDrumkits_SFZ/BLONDE_BOP_SFZ.zip'

  'https://archive.org/compress/breakcore-is-not-a-good-way-to-get-laid-sample-pack/formats=FLAC&file=/breakcore-is-not-a-good-way-to-get-laid-sample-pack.zip'

  'https://www.mediafire.com/?7y485sc5j4e30ve|0__PROD.+DESTROYED+drum+kit.zip'
  'https://www.mediafire.com/?08ymkkzkjx6drmd|deep_house_drum_samples.zip'
  'https://www.mediafire.com/?7q81baqf23ybz7x|dubstep_empire_drum_kit.zip'
  'https://archive.org/download/e0fafeb1f136717ef96884b8a4111417_nikutrax_resources_sample_pack1/nikutrax_resources_sample_pack1.zip'
  'https://www.mediafire.com/?u93flcgf3amh1cb|op-1_drum_sampler_patches.zip'
  'https://www.mediafire.com/?1267oypxy9ayfwa|PeeJay+-+Volume+I+%28Drum+Kit%29.zip'
)

sound_design=(
  'https://opengameart.org/sites/default/files/rpg_sound_pack.zip'
  'https://opengameart.org/sites/default/files/Owlish%20Media%20Sound%20Effects.zip'
)

array_array_of_links=(
  piano
  percussion
  organ
  guitar
  strings
  pipes
  synths
  sound_sets
  drums
  sound_design
)

archive_pattern="\.(zip|7z|tar\..{2,3})$"

get_extract_path(){
  echo $1 | sed -E "s~$archive_pattern~~"
}

download_paths=()
samples_dir=$HOME/Music/samples

echo "Gonna fetch sample packs now..."
for link_array_name in "${array_array_of_links[@]}"; do
  declare -n links="$link_array_name"
  out_path="$samples_dir/$link_array_name"
  mkdir -p "$out_path"

  for link in "${links[@]}"; do
    if [[ $link =~ .*\|.* ]]; then
      download_path="$out_path/$(echo "$link" | sed 's/.*|//')"
      link=$(echo "$link" | sed 's/|.*//')
    else
      download_path="$out_path/$(echo "$link" | sed 's|.*/||')"
    fi

    extract_path=$(get_extract_path "$download_path")
    if [[ -e  $extract_path && $(ls -A "$extract_path") != '' ]]; then
      echo "File '$extract_path' exists, skipping..."
      continue
    fi

    download_paths+=("$download_path")

    if [[ -e $download_path && $(7zz t "$download_path" > /dev/null 2>&1; echo $?) -eq 0 ]]; then
      echo "File '$download_path' exists, skipping..."
      continue
    fi

    echo "Downloading '$link'"
    set -v
    curl -L "$link" --output "$download_path"
    set +v
    echo
  done
done

error_files=()

echo "Gonna extract archives now..."
for download_path in "${download_paths[@]}"; do
  echo "$download_path"
  extract_path=$(get_extract_path "$download_path")

  if [[ $(7zz t "$download_path" > /dev/null 2>&1; echo $?) -ne 0 ]]; then
    echo "$download_path is broken, skipping..."
    error_files+=("$download_path");
    continue
  fi

  set -v
  mkdir -p "$extract_path"
  atool "$download_path" -X "$extract_path"
  set +v
  echo
done

echo "Cleanup..."
for file in "$samples_dir"/*/*; do
  command=
  if [ -d "$file" ]; then
    files_in_dir=("$file"/*)
    if [ ${#files_in_dir[@]} -eq 1 ]; then
      # echo ${files_in_dir[0]}
      command="
mv \"${files_in_dir[0]}\"/* \"$file/.\"
rm -rf '${files_in_dir[0]}'
      "
    fi
  else
    if [[ -e $file && $file =~ $archive_pattern ]]; then
      command="rm \"$file\""
    fi
  fi
  if [ -n "$command" ]; then
    echo "$command"
    eval "$command"
    echo
  fi
done

echo "Done 😎"
if [ -z "${error_files[@]}" ]; then
  echo "No errors found! :D"
else
  echo "Errors found in:"
    for file in "${error_files[@]}"; do
      echo "$file"
    done
fi
