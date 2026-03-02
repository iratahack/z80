# Z80 Sample Applications

Collection of multi-platform Z80 assembly and C applications targeting classic retro computing systems. Each project demonstrates core concepts like graphics programming, interrupt handling, memory banking, and platform-specific APIs.

## Supported Platforms

| Platform | Project Directories | Description |
|----------|-------------------|-------------|
| **Aquarius** | aquarius, aquarius-plus, aquarius-plus-c, aquarius-plus-asm, aquarius-rom | Classic home computer with 48KB RAM |
| **SMS (Sega Master System)** | sms, sms_test | Game console with VDP graphics hardware |
| **CPC (Amstrad CPC)** | cpc_test, cpc_sprite | 8-bit computer with advanced graphics |
| **ZXN (ZX Spectrum Next)** | zxn_test | Modern Z80 FPGA board with enhanced specs |
| **Game Boy** | gb_test | Handheld gaming system |
| **MSX** | msx_test | ASCII computer standard |
| **Other** | keyboard, P3, zx_chibiwave, aq_loader | Specialized projects |

## Prerequisites

- [Z88DK](https://github.com/z88dk/z88dk) - Z80 compiler/assembler/linker suite
- **Build tools**: `make`, standard Unix utilities
- **Platform emulators** (optional, for `make run`):
  - `blastem` - SMS emulator
  - `zesarux` - ZXN emulator
  - Others as configured per platform

## Building

### Build All Projects
```bash
make all           # Compile all applications
make clean         # Remove all build artifacts
```

### Build Specific Project
```bash
cd <project_directory>
make               # Build the application
make clean         # Clean artifacts
make dis           # Disassemble binary (requires mapfile)
```

### Run with Emulator
```bash
cd <project_directory>
make run           # Build and run with configured emulator
```

## Project Descriptions

### Aquarius Family
- **aquarius**: Simple C program printing text (minimum example)
- **aquarius-plus**: Extended memory program with ISR support
- **aquarius-plus-c**:  Multi-bank C programs using banking
- **aquarius-plus-asm**: Assembly with bank switching (32KB extended)
- **aquarius-rom**: ROM cartridge format
- **aq_loader**: Bootable loader with compressed graphics pipeline

### SMS (Sega Master System)
- **sms_test**: Full-featured demo with sprite handling, scrolling, collision, and PSG audio

### CPC (Amstrad CPC)
- **cpc_test**: Basic mode 0/1/2 graphics demo
- **cpc_sprite**: Sprite engine with ISR-driven animation and WyzProPlay music

### ZXN (ZX Spectrum Next)
- **zxn_test**: Sprite graphics and tile system (uses FPGA tilemap hardware)

### Other Platforms
- **gb_test**: Game Boy minimal example
- **msx_test**: MSX standard system demo
- **keyboard**: ZX Spectrum keyboard scan example
- **P3**: SMS platform test
- **zx_chibiwave**: Audio synthesis example

## Build Output

Each platform produces a distinct binary format:
- `.bin` - Raw binary
- `.sms` - Sega Master System ROM
- `.caq` - Aquarius program
- `.rom` - ROM cartridge
- `.nxt` - Preprocessed graphics (intermediate format)

## Project Structure

```
.
├── Makefile              # Root build orchestrator
├── README.md
├── .github/
│   └── copilot-instructions.md  # AI agent guidelines
├── aquarius*/            # Aquarius platform projects
├── sms*/                 # SMS platform projects
├── cpc*/                 # CPC platform projects
├── zxn_test/             # ZXN platform project
└── [other platforms]     # Individual platform implementations
```

## Code Organization

- **C Code**: Standard Z88DK with ANSI C headers
- **Assembly**: Z80 assembly with Z88DK syntax
- **Pragma Configuration**: `.inc` files define memory layout and compiler flags
- **Asset Pipeline**: PNG → gfx2next → `.nxt` → linked binary
- **Audio**: WyzProPlay music engine (preprocessed `.mus` files)

## Memory Management

Z80 systems use constrained memory models (typically 64KB):
- **Fixed CRT Origin**: Memory layout defined via `#pragma output CRT_ORG_CODE`
- **Banking**: Multi-bank systems use `CRT_ORG_BANK_*` pragmas
- **Platform-Specific**: Each system has unique memory organization (see project `.inc` files)

## Development

Recommended workflow:
1. Choose target platform and project directory
2. Review platform-specific headers (e.g., `#include <sms.h>`)
3. Follow naming conventions: lowercase with underscores
4. Test incrementally: `make clean; make; make run`
5. Use `make dis` to inspect generated assembly

## Additional Resources

- [Z88DK Documentation](http://www.z88dk.org/)
- [Z80 Assembly Reference](http://www.z80.info/)
- Platform-specific documentation linked in project Makefiles
