# Z80 Retro Computing Projects - AI Agent Guidelines

This workspace contains multi-platform Z80-based applications targeting classic gaming and computer systems.

## Code Style

- **C Code**: Standard Z88DK conventions with ANSI C. Use `#include <stdio.h>`, `#include <stdlib.h>` for standard libs.
- **Assembly**: Z80 assembly with Z88DK syntax. Use directive syntax like `#pragma` and sections (`section rodata`, `section data`).
- **Naming**: Use lowercase with underscores (e.g., `draw_sprite`, `update_tilemap`, `player_x`).
- **Comments**: Explain the "why" especially for platform-specific code and memory-constrained optimizations.
- **Platform-Specific Headers**: Each platform has its own include path (e.g., `#include <sms.h>` for SMS, aquarius libs for Aquarius).
- **Include Files**: `.inc` files are used for Z80DK pragma settings and shared macros—always source them via `#include "filename.inc"` in assembly.

See: [aquarius/main.c](aquarius/main.c), [sms_test/test.c](sms_test/test.c) for C patterns. [aquarius-plus/main.asm](aquarius-plus/main.asm), [aquarius-plus-asm/zpragma.inc](aquarius-plus-asm/zpragma.inc) for assembly patterns.

## Architecture

**Multi-Target Platform Structure**: Each application subdirectory targets one or more Z80-based systems:
- **Aquarius**: Classic home computer (`aquarius/`, `aquarius-plus/`, `aquarius-plus-c/`, `aquarius-plus-asm/`, `aquarius-rom/`)
- **SMS (Sega Master System)**: Game console with VDP graphics (sms_test/, sms/)
- **CPC (Amstrad CPC)**: Classic computer with graphics (cpc_test/, cpc_sprite/)
- **ZXN (ZX Spectrum Next)**: Modern Z80 board with enhanced specs (zxn_test/)
- **Other**: GB (Game Boy), MSX, GBA, etc.

**Core Patterns**:
- Each platform has own `Makefile` specifying `zcc +platform` target
- Shared components like asset tools (gfx2next) are in subdirectories
- Platform abstractions via conditional includes (e.g., `#ifdef _SMS`)
- Memory organization via `#pragma output CRT_ORG*` declarations in `.inc` files
- Graphics pipelines: PNG → tool (gfx2next) → `.nxt` format → linked binary

## Build and Test

**Build System**: Uses `make` with Z88DK's `zcc` compiler (C and assembly unified).

**Root Build Commands**:
```bash
make all           # Build all applications
make run           # Build and run default emulator for each
make clean         # Remove all build artifacts
```

**Per-Project Build**:
```bash
cd <project_dir>
make               # Build the project
make run           # Run with platform emulator (if configured)
make dis           # Disassemble result (uses z88dk-dis)
make clean         # Clean artifacts
```

**Required Tools**:
- [Z88DK](https://github.com/z88dk/z88dk) - Z80 compiler/assembler/linker suite
- Platform emulators (blastem for SMS, other systems have respective emulators) - configured in Makefiles' `run` targets
- Build tools: `make`, standard Unix tools
- Optional: Asset tools like gfx2next (included in [sms_test/Gfx2Next/](sms_test/Gfx2Next/))

**Typical Build Flow**:
1. Source `.inc` files load pragma directives (memory layout, compilation flags)
2. `zcc` compiles mixed C+assembly via pragmas
3. Link step uses `-create-app` flag to generate platform-specific binary (`.bin`, `.sms`, `.caq`, etc.)
4. Optional: Asset preprocessing (PNG→NXT via gfx2next, compression via z88dk-zx0)

## Project Conventions

**Pragma Configuration** (`zpragma.inc` pattern):
- Defines CRT origin (`CRT_ORG_CODE`), memory banks, optimization flags.
- Sourced via `#pragma include` directive in Makefiles or assembly files.
- Example: [aquarius-plus-asm/zpragma.inc](aquarius-plus-asm/zpragma.inc) sets multi-bank memory layout.

**Platform Conditionals**: Use compiler flags (e.g., `-D_SMS`, `-DGB`) to conditionally compile code.

**Asset Pipeline**: Graphics and music files → preprocessed binary formats → included in binaries:
- PNG images → `.nxt` (Next format) via gfx2next
- Assembly music → `.inc` includes (e.g., [sms_test/wyzproplay_msx.asm](sms_test/wyzproplay_msx.asm))
- Compression: z88dk-zx0 for ZX0 compression

**Memory Constraints**: Z80 systems have tight memory (~64KB). Code frequently manages:
- Bank switching (see pragma `CRT_ORG_BANK_*` declarations)
- Static memory layout (fixed CRT origin)
- Inline optimization in hot paths

**Debugging**: Use `z88dk-dis` for disassembly analysis when needed. Mapfiles (`.map`) contain symbol table information.

## Integration Points

**External Dependencies**:
- Z88DK standard library headers (sms.h, font libraries, PSG audio playback)
- System-specific BIOS/kernel routines (assembled as CRT modules)
- User-provided assets (PNG sprites, music files)

**Cross-Platform Patterns**:
- [sms_test/isr.asm](sms_test/isr.asm) - Interrupt service routines (platform-specific)
- [cpc_sprite/BIOS/](cpc_sprite/BIOS/) - Low-level system abstractions
- [cpc_sprite/music/](cpc_sprite/music/) - Audio driver integration

**Build Artifacts**: Each platform produces a distinct binary format:
- `.bin` - Raw binary (can be used by multiple platforms)
- `.sms` - Sega Master System ROM
- `.caq` - Aquarius program (requires loader)
- `.rom` - ROM cartridge format
- `.nxt` - Preprocessed graphics format

## Security

**No security-sensitive operations** in typical use (retro systems). Note:
- Assembly code operates without protection (direct memory access)
- ISR code runs in privileged context—verify timing and side effects
- Custom tools (e.g., gfx2next) process untrusted assets—validate input formats

## Common Workflows for AI Agents

**Adding a new feature to existing platform**:
1. Identify target project directory (e.g., `sms_test/`)
2. Check platform-specific headers in includes
3. Review existing `.c` or `.asm` patterns in that directory
4. Make edits following platform's pragma settings (in `.inc`)
5. Test: `cd <project>; make clean; make; make run`

**Porting code to new platform**:
1. Create new project directory
2. Copy `Makefile`, adapt `TARGET?=+newplatform` and includes
3. Create `*.inc` pragma file if needed (memory layout, flags)
4. Reimplement platform-specific calls (ISR, graphics, audio)
5. Add to root [Makefile](Makefile) APPS list
6. Test build chain: `make -C newproject`

**Debugging build issues**:
- Check Makefile target: `zcc +platform` must match Z88DK's supported platforms
- Verify pragma includes are loaded before platform-specific code
- Review compiler output for missing headers or undefined symbols
- Use `make dis` to inspect generated assembly
