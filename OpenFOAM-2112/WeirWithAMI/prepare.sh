#! /bin/bash
. /usr/lib/openfoam/openfoam2112/etc/bashrc

cd MeshA
rm -r constant/polyMesh
rm -r 0
rm -r processor*
blockMesh

# ------------------------------------------
# Run snappyHexMesh in parallel.
# This might be a bit more difficut to setup in cluster environments
cp system/decomposeParDict.scotch system/decomposeParDict
decomposePar
cp system/decomposeParDict.ptscotch system/decomposeParDict
mpirun -np 24 snappyHexMesh -parallel -overwrite
reconstructParMesh -constant
renumberMesh -overwrite
cp system/decomposeParDict.scotch system/decomposeParDict
rm -r processor*
# ------------------------------------------
# Run snappyHexMesh serially.
#snappyHexMesh -overwrite
#renumberMesh -overwrite
cp system/decomposeParDict.scotch system/decomposeParDict
# ------------------------------------------
cd ..

cd MeshB
rm -r constant/polyMesh
rm -r 0
rm -r processor*
blockMesh

# ------------------------------------------
# Run snappyHexMesh in parallel.
# This might be a bit more difficut to setup in cluster environments
cp system/decomposeParDict.scotch system/decomposeParDict
decomposePar
cp system/decomposeParDict.ptscotch system/decomposeParDict
mpirun -np 24 snappyHexMesh -parallel -overwrite
reconstructParMesh -constant
renumberMesh -overwrite
cp system/decomposeParDict.scotch system/decomposeParDict
rm -r processor*
# ------------------------------------------
# Run snappyHexMesh serially.
#snappyHexMesh -overwrite
#renumberMesh -overwrite
cp system/decomposeParDict.scotch system/decomposeParDict
# ------------------------------------------
cd ..

cd MeshC
rm -r constant/polyMesh
rm -r 0 30
rm -r processor*
blockMesh
cd ..

cd MeshA
mergeMeshes -overwrite . ../MeshB
mergeMeshes -overwrite . ../MeshC

topoSet -constant
createBaffles -overwrite

cp -r 0.model 0
setFields
decomposePar
