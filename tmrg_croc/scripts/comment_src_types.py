#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Usage:
  1. Process single file: python comment_src_types_fixed.py mydesign/top.sv
  2. Process all .sv files under a directory: python comment_src_types_fixed.py mydesign/
"""

import os
import re
import sys


def process_file(filepath):
    """
    Process a single SystemVerilog (.sv) file.
    - Comment out any line that defines 'parameter type'.
    - If the commented line was the last parameter in a list, remove
      the trailing comma from the previous parameter line.
    """

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    in_param_block = False
    param_block_indices = []  # list of (start, end) line indices for parameter blocks

    # --- First pass: detect all parameter blocks (#( ... )) ---
    for i, line in enumerate(lines):
        if not in_param_block and re.search(r'#\s*\(', line):
            in_param_block = True
            start_idx = i
        if in_param_block and re.search(r'\)\s*[;)]', line):
            in_param_block = False
            end_idx = i
            param_block_indices.append((start_idx, end_idx))

    # --- Second pass: modify lines inside parameter blocks ---
    for i, line in enumerate(lines):
        modified = line

        # check if this line is inside any parameter block
        inside_block = any(start <= i <= end for start, end in param_block_indices)

        if inside_block and re.search(r'parameter\s+type\b', line):
            # find if this parameter type is the last 'parameter' line in the block
            block = next((b for b in param_block_indices if b[0] <= i <= b[1]), None)
            is_last_param = True
            if block:
                for j in range(i + 1, block[1] + 1):
                    if re.search(r'^\s*parameter\b', lines[j]) and not re.search(r'parameter\s+type\b', lines[j]):
                        is_last_param = False
                        break

            # only remove comma from previous parameter if this is truly the last parameter
            if is_last_param:
                j = len(new_lines) - 1
                while j >= 0:
                    prev_line = new_lines[j].rstrip()
                    if prev_line.strip() and not prev_line.strip().startswith('//'):
                        new_lines[j] = re.sub(r',\s*$', '', prev_line) + '\n'
                        break
                    j -= 1

            # comment out this line
            if not line.lstrip().startswith('//'):
                modified = '// ' + line

        new_lines.append(modified)

    # --- Write back the modified file ---
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

    print(f"Processed: {filepath}")


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
