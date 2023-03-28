#!/bin/bash
#SBATCH --account=owner-guest
#SBATCH --partition=notchpeak-guest
#SBATCH --nodes=1
#SBATCH --time=00:10:00
#SBATCH --mail-user=brett.milash@utah.edu
#SBATCH --mail-type=ALL


module load R/4.2.2
Rscript plot_files.r HEADERS.txt CRND*.txt
