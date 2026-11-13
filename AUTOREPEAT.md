# Stevie keyboard autorepeat

This local build adds autorepeat to upstream Stevie commit
`2d470961f5c5a6d3bf6b9ba4438921f8c9c039a3`.

Revision 9 fixes the corresponding line-deletion defects. Deleting from a
2,048-line file needs the multi-page index path. For larger files, the
spare index slot must be cleared before the text/framebuffer windows are
restored. The old code cleared it afterward, so that address could refer
to text instead of an index entry.

The user's R8 attachment contains four NUL bytes in line 2039, replacing
one space and `DEC` in `       DEC  R3`. With the actual XB Packer/DSR
files, inserting five blank lines near that instruction then deleting two
reproduces the same four-byte pattern. Revision 9 preserves the instruction
and every other record, in memory and on save.

The larger deletion tests also exposed an existing import-page problem:
the progress callback can refresh the screen using another text page. The
importer now checks and restores its write page before the next record.
An import ending at 4,096 lines reproduces this in the 60-line build when
the first progress refresh coincides with a new text-page allocation.

Revision 8 fixes line-index insertion across a 2,048-line boundary. The
single-page shift routine could write its final destination outside the
index window, into editor text memory. Appending also bypassed the
multi-page check. The index now maps multiple pages whenever the destination
slot crosses a boundary, including an insertion at the end of a file.

The user's exact CTRL-I failure was reproduced using the local 1,910-line
XB Packer source and its 138-record DSR/GPL file. Record 120,
`       BLWP @GPLLNK                Execute DSR LINK`, is the first record
on a newly allocated text page. The final index shift cleared its length
word, making that line blank in the buffer and saved file. Revision 8
preserves it. The import file on disk was intact.

CTRL-I now also commits a pending edit on the current row before mapping
dialog pages and importing, so the refresh does not discard that edit.

Revision 7 fixes saving an edited line before moving the cursor off it.
The upstream Save dialog mapped its strings over the SAMS index window
before committing the current line. The index cache could then leave an
update in the dialog-data page instead of the real line index, losing the
edit and corrupting dialog data. The line is now committed before either
dialog page is mapped. Print already used this ordering.

The failure reproduces with an ordinary CPU rate and with eight times as
many CPU cycles per video frame, so overdrive is not required to trigger it.
This is a controlled emulator timing stress test, not Classic99 itself.
The user's separate report of invisible characters had not been reproduced
in revision 7; revision 9 adds a matching four-NUL corruption case.

Revision 6 fixes the command-field length used by Find. Appending a character
previously counted it twice when updating the length prefix: entering `INSTAL`
stored a seven-character query, including the following null byte. Find now
uses the actual six-character length. The defect is present in the upstream
2.0.7 source and was retained in revisions 1-5.

The new native search tests load D/V80 files through the emulated disk DSR,
type queries through the real keyboard and Find dialog, compare every match
and its position with the original records, and exercise next/previous match,
remembered queries, clearing, append, insert and delete. Tests cover upper and
lower case, no matches and empty queries. Search remains case-sensitive.

Revision 5 fixes a confirmed cursor-restoration defect in direct FCTN-0
BASIC resumes. Returning to an editor with no menu open now keeps the
dialog closed, restores its logical cursor position and restarts blinking.
Menu-based returns retain the BASIC menu and its SPACE unpack operation.
This defect also exists in 1.9.10; it is not yet established as the complete
cause of the user's intermittent loss of editing after BASIC round trips.

Revision 4 fixes the upstream AutoUnpack toggle bug confirmed on real
hardware. The toggle now stores the marker-list pointer in `cmdb.keycolors`
instead of the label-text pointer. This prevents the color renderer from
interpreting text as position/count pairs and overrunning its work buffer.

Revision 3 makes the editor's shortcut bar use the normal bar text color
in every color scheme, including the TI BASIC and search-result layouts.
The labels now read `F9-Menu  ^H-Help`, with dashes added to the other
shortcut/function pairs in these layouts too. String widths and field
positions are preserved.

Revision 2 fixes the color-change loop reported after the first build.
Returning commands now resume the scheduler instead of returning to the
same key event. The default palette's F9 and ^H bottom-bar labels are black
on cyan, matching the adjacent text.

Pressing a key acts immediately. Holding an eligible key starts repeating
after 500 ms, at approximately 12 characters/actions per second (12 at
60 Hz, 12.5 at 50 Hz). Release stops repeat on the next keyboard scan.

These inputs repeat:

- Ordinary printable text, including spaces and shifted punctuation, in
  the editor and command input fields.
- FCTN-S/D/E/X cursor movement.
- FCTN-1 character deletion in the editor and command input.
- FCTN-E/X previous/next file selection in catalog dialogs.

ENTER, save/open/quit commands, menu choices, block marking, line deletion,
and toggles remain one action per press. SPACE used as a command, such as
going up a directory, also remains one action per press. Changing pane,
dialog, or held modifiers cancels repeat until a fresh key press.

## Cartridge images

`build/autorepeat/` contains four independent, non-inverted 128 KB ROM
images, using the same format and filenames as upstream:

| File | Display mode |
| --- | --- |
| `stevie24_8.bin` | 24 rows, 80 columns |
| `stevie30_8.bin` | 30 rows, 80 columns |
| `stevie48_8.bin` | 48 rows, 80 columns |
| `stevie60_8.bin` | 60 rows, 80 columns |

Choose the same display mode you normally use with Stevie. Put the chosen
image in a separate folder on your FinalGROM99 SD card and launch it as
usual. Stevie's existing video and SAMS requirements still apply. The
checked-in upstream cartridge images in `build/bin/` have not been replaced.

## Implementation

The keyboard hook now runs once per VDP frame after the console KSCAN.
ROM bank 8 holds the repeat state machine because bank 1 has little space
left. Bank 8 vector 1 is its entry point; its previously unused bank ID is
corrected to `bank8.rom`. The existing ROM trampoline restores bank 1 and
both stacks after each call. Fourteen bytes of previously free core RAM,
`>a036` through `>a043`, hold repeat state.

The first decoded key is retained during a hold. Spectra2's RKSCAN resets
the console's modifier cache before each scan; reading its later translated
keycode directly can turn held FCTN-S into an ordinary `s`. The repeat
engine instead reads the physical FCTN/SHIFT/CTRL matrix bits to detect
modifier changes and replays the original decoded event. Spectra2 is
unchanged.

The normal dispatcher resolves the active keymap before arming repeat.
Only the approved action addresses in `keymap_repeat.actions` and validated
character input handlers enable it. This keeps printable menu shortcuts and
context-dependent SPACE commands from repeating.

Timing constants are at the top of `src/modules/edk.key.repeat.asm`.
They are frame counts; rebuild after changing them.

## Build and validation

The portable build script uses Python's standard library and xdt99. With
sibling `spectra2` and `xdt99` checkouts beside this repository, run:

```text
python build/build_autorepeat.py
```

Use `--assembler PATH` or `--spectra2 PATH` to select other locations.
The script builds every bank for all four display modes, checks the bank
sizes, and puts images, listings, and symbol files in `build/autorepeat/`.

Versions used:

- Spectra2 `3683b89bac1bab2f6d565211e0de0765c0f63080`
- xdt99 3.6.5, commit `a77bd3183ff64baacc490dc9cd80b6c7552037ec`
- Old-Js99er `6854b2a911431260771939eddb9511d9567cd875`

For automated keyboard tests, use Node.js with a sibling `test-emulator`
checkout of `https://github.com/Rasmus-M/Old-Js99er`:

```text
node build/test_autorepeat.cjs 3080
```

The tests execute the assembled cartridge's actual scheduler, Spectra2
scanner, TI console ROM/GROM KSCAN, ROM bank trampoline, repeat engine,
dispatcher, and character-handler validation in Js99er's TMS9900 emulator.
They check NTSC/PAL timing, held modifiers, release, changing keys, repeat
eligibility, context changes, and stack/bank restoration. Screen and file
action bodies are generally intercepted after dispatch. Additional tests
run the real banked color-change command and its return path (with redraw
helpers bypassed), exercise commands that return through R11, and execute
the actual bottom-bar key-color painter through its VRAM writes. These are
keyboard/rendering integration tests rather than a full editor UI test.
Revision 4 passes 56 tests per display mode (224 total), including all
12 color schemes across the four editor shortcut-bar layouts. The AutoUnpack
tests load the actual dialog data, dispatch FCTN-5 through the real handler,
toggle on/off twice per scheme, and execute every redraw. They verify the
text/color pointers, all 80 VRAM color bytes, guard bytes after the work
buffer, keyboard responsiveness, and stack/bank restoration. Holding FCTN-5
must not toggle repeatedly.

The user confirmed that revision 4 no longer freezes when toggling
AutoUnpack on the real TI/Pico9918.

Run the search regression tests with:

```text
node build/test_search.cjs --mode=6080
node build/test_search.cjs --mode=6080 "--file=C:\path\to\XBP14;S"
```

The default uses a synthetic D/V80 fixture. `--file` loads an existing TIFILES
file without modifying it. The local `XB Packer/dist/XBP14;S` has 1,910 records;
revision 6 finds all three `INSTAL` matches at lines 47, 997 and 1464, with
the correct columns. Revision 5 fails the typed-command length regression.

The full BASIC/session regression test executes the complete editor and
native BASIC interpreter, with SAMS and the F18A/GPU model. It checks menu,
direct FCTN-0 and mixed entry paths, three sessions, empty BASIC sessions,
a one-line program, manual/automatic unpack, menu dismissal, typing, cursor
movement, the logical cursor position, and continued cursor blinking after
return. It leaves the cursor on different editor rows between visits.

```text
node build/test_basic_sessions.cjs --mode=6080 --mixed --empty-basic --quiet
```

Revision 5 passes six scenarios of six round trips per display mode
(144 round trips total), in addition to the 224 keyboard/rendering tests.
The FCTN-0 regression check fails on revision 4 at the second return with
an invisible BASIC dialog (`cmdb.dialog=107`, `cmdb.visible=0`). The original
1.9.10 image exhibits the same defect. Emulator checks do not establish
that revision 5 resolves every symptom on the user's real hardware.

The file-integrity regression test loads 4,000 D/V80 records with lengths
from zero through 80 characters, saves unchanged, edits lines around SAMS
index boundaries, and saves immediately from the dirty row. Every record
is compared after every save, and both dialog-data pages must remain intact.
It checks normal CPU timing and eight times as many CPU cycles per frame.

```text
node build/test_file_integrity.cjs --mode=6080 --cpu-factor=1
node build/test_file_integrity.cjs --mode=6080 --cpu-factor=8
```

Revision 6 loses the edit on the current line in this test at either speed.
Revision 7 passes all 56 save checks (seven per mode/speed combination),
comparing 224,000 records in total. The keyboard, Find and BASIC regression
suites are also rerun for every display mode by `build/validate_r7.py`.
Revision 9 adds a matching reproduction for the invisible NUL characters
found in the later attached source.

The insertion regression tests compare every packed row immediately after
CTRL-I and every saved record. Cases cover the 2,048/4,096-line boundaries,
middle/end insertion, FCTN-8 line insertion, and pending current-row edits.
The actual XB Packer/DSR files are also tested at both CPU factors in all
display modes. The original files are read without modification.

```text
node build/test_file_insert.cjs --mode=6080
node build/test_file_insert.cjs --mode=6080 --records=4095 --at=4095
node build/test_file_insert.cjs --mode=6080 --dirty
```

`--base=PATH` and `--import=PATH` select existing TIFILES instead of synthetic
records. `build/validate_r8.py BASE IMPORT` runs the insertion cases and all
prior keyboard, Find, save-integrity and BASIC tests for every display mode.
Revision 8 passes all 80 suites, including 36 insertion scenarios. The
exact BLWP-line failure is covered with the original local files in all
four modes at normal and accelerated CPU timing.

The deletion tests also cover files at and above 2,048/4,096 lines,
deletions at the beginning/end, and the exact DEC-to-NUL corruption pattern.

```text
node build/test_file_delete.cjs --mode=6080
node build/test_file_delete.cjs --mode=6080 --records=3958 --extra-lines=0
```

`build/validate_r9.py BASE IMPORT` includes these cases alongside all prior
regression suites. The actual source and import are read without modification.
Revision 9 passes all 116 suites, including 32 deletion scenarios and 40
insertion scenarios, across every display mode. The suite includes both
normal and accelerated CPU timing for the actual-file corruption case.
