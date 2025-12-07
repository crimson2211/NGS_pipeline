# NGS Pipeline Project
Automated Nanopore analysis pipeline using Dorado, Kraken2, and Abricate.
For tetsing use .pod5 file or file and make changes in the data path in the .sh file.  

## Usage
./pipeline.sh

# NGS Bioinformatics Pipeline

This repository contains the orchestration scripts for a Nanopore sequencing analysis pipeline. 

## ⚠️ Important: Environment Setup
The large data files (\`.pod5\`, \`.fastq\`) and binary tools are **not** included in this repository. To reproduce this pipeline, you must set up the following directory structure:

### Directory Structure
- \`data/\`: Place raw Nanopore \`.pod5\` files here.
- \`results/\`: Output directory for classified reads and AMR tables.
- \`tools/\`: Local installation directory for software binaries.
  - \`bin/\`: Contains \`blastn\`, \`any2fasta\`, \`diamond\`.
  - \`abricate/\`: Abricate source and database.
  - \`kraken2/\`: Kraken2 binary.
  - \`kraken2_db/\`: MiniKraken2 database.

### Software Dependencies
The pipeline expects the following tools to be manually installed in \`tools/\`:
1. **Dorado (v0.7.1):** For high-accuracy basecalling.
2. **Kraken2:** For taxonomic classification.
3. **Abricate:** For AMR gene detection (requires BLAST+ and any2fasta in PATH).
4. **BLAST+ (v2.16.0):** Required engine for Abricate.

## Usage
1. **Activate Environment:** \`source ngs_env/bin/activate\`
2. **Execute Pipeline:** \`./pipeline.sh\`
3. **Generate Visuals:** \`python3 ploting_pipe.py\` creates \`benchmark_graph.png\`.

## File Structure 
NGS_Pipeline/
├── tools/
│   ├── bin/
│   │   └── .gitkeep  <-- Placeholder is here
│   ├── dorado_models/
│   │   └── .gitkeep  <-- Placeholder is here
│   └── kraken2_db/
│       └── .gitkeep  <-- Placeholder is here
├── pipeline.sh
└── .gitignore

