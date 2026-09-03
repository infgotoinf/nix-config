#!/usr/bin/env bash

# This script depends on atool, curl and 7zz

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

  'https://download1478.mediafire.com/4cvjknxjkfsgfDHdwFCOwIBKZAwor3GPn9m9K79TYAjku7n5Rupo7AzFucwGg-ytHPc7Srdt1RsUUIriq1QNsddirGxZFvfrQQlSN8iSLBxm61b8p2eCYgHwGL5CuqL5eGOlsoxAzV3dc2RdIfsDuYK3CGZII7gmkoCcBUH0O6sWlta6/6wmk6gexd4wgv8t/Live+Percussion+Sample+Pack.zip'
  'https://download2389.mediafire.com/pjmxlgfmp1bgS5xhMhrfnshQ7Wlu-4B6ox1eZtWZOe9ioe-tybTiYUwV4e1E2B63PExIVBNCqlMQ6aMRAA5FiMQiYMEnzxA1UDTa2mq17UZBgYKDyVZ5KLAx8gKGHMc0HeHo_7A6jkl7TUz8rjTD9fGytrkV91SNk1mhSeH-To-ekOtg/0230qm71pt6t122/Music_2000_Sample_library_44k_WAV.zip'
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

  'https://download2294.mediafire.com/3c375mclhtugZr5HHU9hCB61Uaoy-pE0vhHQVvDZRHjdBZmFq88qbLL33fppdhOqStaxqHnAfYRM6vBYBT88y_tdYmtpVxZWOXe3j34-vM4Tw3cOJEnhXx01g5wxpR9BflNvX8EFMO-EDLhnk-a7eb8I_GCgg2XoazxdZ3xJ4Cqa2BIK/v9ga7r6oprv0n72/G-Town+Church+Sampling+Project.zip'
)

drums=(
  'https://archive.org/compress/breakcore-is-not-a-good-way-to-get-laid-sample-pack/formats=FLAC&file=/breakcore-is-not-a-good-way-to-get-laid-sample-pack.zip'

  'https://download1500.mediafire.com/k4sukdowvcjg_sgSdYzVPtYgovwREFTzRACbFpIkvHT8e59jE2l4Y89_7utOGZV4nGgbujAz06BxU_Vqvs4p5sNhdX8li0KCcUhXcqlbhYXej5508VKiG9-amwgTB-JvLVs601PDob1LIgLMXbWNPYntF_Icgqa-Ji3AlqIFFqe3Nz_R/7y485sc5j4e30ve/0__PROD.+DESTROYED+drum+kit.zip'
  'https://download2390.mediafire.com/5do51byo1rpgzhNEifMgxjW6tWN8bPd3U_ilM0TLIoYJXZ3TVLJ_RfI-MecwLlWNnGL4UzcAqOQlgS3BBiCB5SimuMGQJV3c-Lxn4fXIA3IIHm9jiqtIV2ieX57tmQPMZl3tr8D4zNN-984CDtaE9kyS2MFqLqwMbeWebwtj_hte1KIY/08ymkkzkjx6drmd/deep_house_drum_samples.zip'
  'https://download2391.mediafire.com/3g5ok3bf2dlgCRWcNAZxChGy8LJsPhzItWengz2IiRCOFJwBe6ldx27Ac3v4ngR6pWX0AT-fqoQ4smtlMFquXPqzh9RKJOR1f0ng8xPu-8kxW11ta59YTfTdUOevWlekP0D9Q1naAzDCiP9z_GZUrNpzODKQ_rr25NdN9HDYgeRhl09f/7q81baqf23ybz7x/dubstep_empire_drum_kit.zip'
  'https://download2389.mediafire.com/vufwrl184dxgCAylrUNwUDfmn9VILU8RXWmxXll36Tyx6qvXeMnaIWTeFWEpCe3nMeCEpvmofd9UjbBERsNZMAHp1MuA5-EIGVeu7LkJgundjt4Qf-4G1vIcfkhrkIgBegA88yRuSgtzjAV4zLo1PKxPGK3rO2-gl4sClst-SRlG6nI2/k1qanbqvm3bftdn/NiKUTRAX+RESOURCES+%5BVOL1%5D.zip'
  'https://download1655.mediafire.com/9z3ttvxpd6ngPpBocgfWtTEVS8a6vV1puzob6QvE-wRlu5BDXbNQVgIXb0-2rG_d-s_Q6Iuqm7g8FK_e-k_2rwAdVo4vY6h12J6aiskPfvU8b_RoAhLnZAzxdW-HLzpae_u6CP_oAObh5QbRR27AHrmY1zKuwp-cTNvYMyHgEV-XVaLH/u93flcgf3amh1cb/op-1_drum_sampler_patches.zip'
  'https://download2281.mediafire.com/grm9djod2sfgSC6MNHPYa-X4oHYoNFKSpZ_LkQ_Diy_7n1c68958_RJS5axqFTSPtrn9obDMdzkp1qQnE-RiG_UvfxJJPy_2o0iF8D1rqW66yrtHLwcneu_JVfDMGC8zXed8crpZ0Afbbtz5HSVHcvj95f9MMFWkI4IxklIa_ZMo5MAF/1267oypxy9ayfwa/PeeJay+-+Volume+I+%28Drum+Kit%29.zip'
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
    download_path="$out_path/$(echo "$link" | sed 's|.*/||')"
    # download_path="$out_path/${link//.*\//}"

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
