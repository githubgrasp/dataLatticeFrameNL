#!/bin/bash
# Clean up OOFEM and related output files from current folder and all subfolders

patterns=("*.vtu" "*.gp" "*.osf" "oofem.out" "voronoi.dat" "nodes.dat" "*~" "#*" "elout" "d3dump*" "d3hsp" "disk*" "lspost.db" "binout*" "d3full*" "lspost*" "random.dat" "field.dat" "*.pov" "core.*" "*.jpeg" "*.jpg" "output*.dat" "std.out" "*.pvd")

for pat in "${patterns[@]}"; do
    find . -type f -name "$pat" -exec rm -f {} +
done

echo "Cleanup complete."
