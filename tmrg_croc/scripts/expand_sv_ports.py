#!/usr/bin/env python3

# usage: 
# 1. process single file: python expand_sv_ports.py mydesign/top.sv
# 2. process all .sv files under a directory: python expand_sv_ports.py mydesign/
import os
import re
import sys

def process_file(filepath):
    """
    Process a single SystemVerilog (.sv) file.
    - Detect module instantiations with shorthand port connections like `.clk_i,`
    - Replace them with explicit `.clk_i(clk_i),`
    - Overwrite the file with the modified content.
    """

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to match `.signal` patterns that are part of port lists
    # and not already using explicit connection `.signal(...)`
    pattern = re.compile(r'\.(\w+)\b(?!\s*\()')

    def replacer(match):
        """Replace .sig with .sig(sig)"""
        sig = match.group(1)
        return f'.{sig}({sig})'

    new_content = pattern.sub(replacer, content)

    # Write back to file only if changed
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated: {filepath}")
    else:
        print(f"No change: {filepath}")


def find_sv_files(path):
    """
    Return a list of all .sv files under the given path.
    - If path is a single .sv file, return [path].
    - If path is a directory, search recursively for .sv files.
    """
    if os.path.isfile(path) and path.endswith('.sv'):
        return [path]

    sv_files = []
    for root, _, files in os.walk(path):
        for name in files:
            if name.endswith('.sv'):
                sv_files.append(os.path.join(root, name))
    return sv_files


def main():
    """
    Entry point: process one or multiple files or directories.
    Usage:
        python comment_src_types_fixed.py <path1> [<path2> ...]
    """
    if len(sys.argv) < 2:
        print("Usage: python comment_src_types_fixed.py <path_to_sv_or_dir> [<more_paths>...]")
        sys.exit(1)

    all_sv_files = []

    # Collect .sv files from all given paths
    for target_path in sys.argv[1:]:
        sv_files = find_sv_files(target_path)
        if not sv_files:
            print(f"No .sv files found under {target_path}")
        else:
            all_sv_files.extend(sv_files)

    if not all_sv_files:
        print("No .sv files found in any provided path.")
        sys.exit(0)

    # Remove duplicates (just in case)
    all_sv_files = sorted(set(all_sv_files))

    # Process all found files
    for f in all_sv_files:
        process_file(f)


if __name__ == "__main__":
    main()
