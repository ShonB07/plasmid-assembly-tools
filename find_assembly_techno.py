#!/usr/bin/env python3
import sys

version = asm = seq_tech = None

print("VERSION\tAssembly Method\tSequencing Technology")

with open(sys.argv[1]) as f:
    for line in f:
        s = line.strip()
        if s.startswith("VERSION"):
            version = s.split()[1]
        elif "Assembly Method" in s and "::" in s:
            asm = s.split("::")[-1].strip()
        elif "Sequencing Technology" in s and "::" in s:
            seq_tech = s.split("::")[-1].strip()
        elif s == "//":
            if version:
                print(f"{version}\t{asm or 'N/A'}\t{seq_tech or 'N/A'}")
            version = asm = seq_tech = None
