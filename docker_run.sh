#!/bin/bash

# Simple Docker-based script to run one benchmark

echo "=== Downloading trace file ==="
mkdir -p traces/spec2k17
if [ ! -f traces/spec2k17/602.gcc_s-734B.champsimtrace.xz ]; then
    curl https://dpc3.compas.cs.stonybrook.edu/champsim-traces/speccpu/602.gcc_s-734B.champsimtrace.xz --output traces/spec2k17/602.gcc_s-734B.champsimtrace.xz
else
    echo "Trace file already exists, skipping download"
fi

echo "=== Building Berti simulator with Docker ==="
docker run -it -v$(pwd):/mnt --rm gcc:7.5.0 /bin/bash -c "cd mnt/ChampSim/Berti; ./build_champsim.sh hashed_perceptron no vberti no no no no no lru lru lru srrip drrip lru lru lru 1 no"

echo "=== Creating output directory ==="
mkdir -p output

echo "=== Running benchmark with Docker ==="
docker run -it -v$(pwd):/mnt --rm gcc:7.5.0 /bin/bash -c "cd mnt; ./ChampSim/Berti/bin/hashed_perceptron-no-vberti-no-no-no-no-no-lru-lru-lru-srrip-drrip-lru-lru-lru-1core-no -warmup_instructions 500000 -simulation_instructions 20000000 -traces traces/bfs-10.txt.xz > output/result.out"

echo "=== Done! ==="
echo "Results saved to: output/result.out"
