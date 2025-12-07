#!/bin/bash

# ================= CONFIGURATION =================
BASE_DIR=$(pwd)
DATA_DIR="$BASE_DIR/Merged_files"
RESULTS_DIR="$BASE_DIR/results"
LOG_FILE="$BASE_DIR/pipeline_benchmark.csv"

# --- TOOLS SETUP ---
# 1. Add our manual bin folder to system path (Fixes blastn, any2fasta, etc.)
export PATH=$HOME/NGS_Project/tools/bin:$PATH

# 2. Tool Paths
DORADO_EXEC="/home/chayanika/dorado-0.7.1-linux-x64/dorado-0.7.1-linux-x64/bin/dorado"
DORADO_MODEL="/home/chayanika/NGS_Project/tools/dorado_models/dna_r10.4.1_e8.2_400bps_sup@v4.2.0"
KRAKEN_DB="/home/chayanika/NGS_Project/tools/kraken2_db/minikraken2_v2_8GB_201904_UPDATE"
ABRICATE_EXEC="$HOME/NGS_Project/tools/abricate/bin/abricate"

# ================= START PIPELINE =================

# Initialize CSV Log (Simple format for Python: File, Step, Seconds)
echo "Filename,Step,Duration" > "$LOG_FILE"

# Create results directory
mkdir -p "$RESULTS_DIR"

echo "Starting Pipeline Benchmark..."

# LOOP through every .pod5 file in data folder
for pod5_file in "$DATA_DIR"/*.pod5; do
    
    # Check if files actually exist
    [ -e "$pod5_file" ] || continue

    filename=$(basename "$pod5_file" .pod5)
    echo "-----------------------------------"
    echo "Processing: $filename"

    fastq_out="$RESULTS_DIR/${filename}.fastq"
    kraken_out="$RESULTS_DIR/${filename}_kraken.txt"
    kraken_report="$RESULTS_DIR/${filename}_kraken_report.txt"
    amr_out="$RESULTS_DIR/${filename}_amr.tsv"

    # --- STEP 1: DORADO (Basecalling) ---
    start=$(date +%s)
    echo "  > Running Dorado..."
    
    "$DORADO_EXEC" basecaller "$DORADO_MODEL" "$pod5_file" --emit-fastq > "$fastq_out"
    
    end=$(date +%s)
    duration=$((end - start))
    # Log time only if successful
    if [ -s "$fastq_out" ]; then
        echo "$filename,1_Dorado,$duration" >> "$LOG_FILE"
        
        # --- STEP 2: KRAKEN2 (Taxonomy) ---
        start=$(date +%s)
        echo "  > Running Kraken2..."
        kraken2 --db "$KRAKEN_DB" --threads 16 --report "$kraken_report" --output "$kraken_out" "$fastq_out"
        end=$(date +%s)
        duration=$((end - start))
        echo "$filename,2_Kraken2,$duration" >> "$LOG_FILE"

        # --- STEP 3: ABRICATE (AMR) ---
        start=$(date +%s)
        echo "  > Running Abricate..."
        "$ABRICATE_EXEC" --db ncbi --threads 16 "$fastq_out" > "$amr_out"
        end=$(date +%s)
        duration=$((end - start))
        echo "$filename,3_Abricate,$duration" >> "$LOG_FILE"
        
        echo "  > Finished $filename"
    else
        echo "  ! Error: Dorado failed for $filename"
    fi

done

echo "-----------------------------------"
echo "Benchmark complete. Data saved to $LOG_FILE"
