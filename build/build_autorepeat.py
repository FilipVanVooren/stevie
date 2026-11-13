"""Build Stevie with a sibling Spectra2 checkout and the xdt99 assembler.

Run from any directory: python build/build_autorepeat.py
Outputs are isolated in build/autorepeat; checked-in release images stay intact.
"""

import argparse
from datetime import datetime
from pathlib import Path
import subprocess
import sys


def main():
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--assembler", type=Path,
                        default=root.parent / "xdt99" / "xas99.py")
    parser.add_argument("--spectra2", type=Path,
                        default=root.parent / "spectra2" / "src")
    parser.add_argument("--modes", nargs="+", type=int,
                        choices=(2480, 3080, 4880, 6080),
                        default=(2480, 3080, 4880, 6080))
    args = parser.parse_args()
    output = root / "build" / "autorepeat"
    info = output / ".buildinfo"
    info.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%y%m%d-%H%M%S0")
    (info / "buildinfo.asm").write_text(f"* AUTOREPEAT BUILD: {stamp}\n")
    (info / "buildstr.asm").write_text(f"        text '{stamp}'\n")
    includes = [info, args.spectra2 / "equates", args.spectra2 / "modules",
                args.spectra2, root / "src" / "modules", root / "src",
                root / "src" / "assets"]
    for mode in args.modes:
        target = output / str(mode)
        target.mkdir(parents=True, exist_ok=True)
        image = bytearray()
        for bank in "0123456789abcdef":
            name = f"stevie_b{bank}"
            cmd = [sys.executable, str(args.assembler.resolve()),
                   "--quiet-unused-syms", "--quiet-opts", "-b", "-S",
                   "-L", str(target / f"{name}.lst"),
                   "-E", str(target / f"{name}.equ"),
                   "-o", str(target / f"{name}.bin"),
                   str(root / "src" / f"{name}.asm"),
                   "-I", ",".join(str(p.resolve()) for p in includes),
                   "-D", f"vdpmode={mode}"]
            subprocess.run(cmd, check=True, cwd=root / "build")
            data = (target / f"{name}.bin").read_bytes()
            if len(data) != 8192:
                raise RuntimeError(f"{name}: expected 8192 bytes, got {len(data)}")
            image.extend(data)
        binary = output / f"stevie{mode // 100}_8.bin"
        binary.write_bytes(image)
        print(f"Built {binary.name}: {len(image)} bytes", flush=True)


if __name__ == "__main__":
    main()
