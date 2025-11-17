#!/usr/bin/env python3
import re
import sys
from pathlib import Path

def extract_modules_from_sv(file_path):
    """Extract top-level module and parameterized submodule instances from a SystemVerilog file."""
    text = Path(file_path).read_text(errors="ignore")

    # Match module definitions
    module_def_re = re.compile(
        # r'(?m)^[ \t]*module\s+(\w+)(?:\s+(?:import\s+\w+(?:::)?\*?;)?\s*)?#\s*\('
        r"(?ms)^[ \t]*module\s+(\w+)(?:\s+(?:import\s+\w+(?:::)?\*?;)?\s*)?[\s\S]{0,200}?(?:#\s*\(|\()"
    )
    # Match parameterized module instances: submod #(...) inst_name (...)
    instance_param_re = re.compile(r'(?<!\bmodule\s)(\b\w+)\s*(?:#\s*\(|\b\w+\s*\(\s*\n)', re.MULTILINE)

    modules = module_def_re.findall(text)
    if not modules:
        print("No module definitions found")
        return

    top_module = modules[0]
    instances = instance_param_re.findall(text)

    # Remove duplicates and sort
    instances = sorted(set(instances))

    print(top_module)
    for i, inst in enumerate(instances):
        connector = "├──" if i < len(instances) - 1 else "└──"
        print(f"{connector} {inst}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python sv_hierarchy_param.py <file.sv>")
        sys.exit(1)

    extract_modules_from_sv(sys.argv[1])
