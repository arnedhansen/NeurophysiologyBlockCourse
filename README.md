# Neurophysiology Block Course - MATLAB & EEGLAB Tutorials

This repository contains teaching materials for a neurophysiology/EEG block course designed for psychology students learning programming with MATLAB and EEG data analysis using EEGLAB.

## Repository Structure

```
NeurophysiologyBlockCourse/
├── Tutorials/              # Self-study tutorials
│   ├── Tutorial1_MATLAB.mlx
│   ├── Tutorial2_DigitaleSignalverarbeitung.mlx
│   ├── Tutorial3_Datenstrukturen.mlx
│   ├── Tutorial4_SaubererCode_Reproduzierbarkeit.mlx
│   ├── Tutorial5_EEGLAB_Grundlagen.mlx
│   ├── Tutorial6_ZeitFrequenzanalyse.mlx
│   ├── Tutorial7_Signale_Filter_ZeitFrequenzGrundlagen.mlx
│   ├── Tutorial8_Datenexport.mlx
│   ├── EN/                # English versions
│   │   ├── Tutorial1_ProgrammingInMATLAB.m
│   │   ├── Tutorial2_DigitalSignalProcessing.m
│   │   ├── Tutorial3_DataStructures.m
│   │   ├── Tutorial4_CleanCodeReproducibility.m
│   │   ├── Tutorial5_EEGLABBasics.m
│   │   ├── Tutorial6_TimeFrequencyAnalysis.m
│   │   ├── Tutorial7_SignalsFiltersTimeFrequency.m
│   │   └── Tutorial8_DataExport.m
│   └── Templates/         # Template files
├── Praxis/                # Practice materials for block course
│   ├── data/              # EEG data files
│   │   ├── raw_data/      # Raw EEG data
│   │   └── preprocessed_data/  # Preprocessed EEG data
│   ├── eeglab2021.1/      # EEGLAB toolbox
│   ├── files_dropbox/     # Practice scripts with solutions
│   └── Praxis_V_Zeit_Frequenz*.m
├── Aufgaben/              # Exercise assignments
│   ├── Aufgaben_Blockkurs.m
│   └── Aufgaben_Blockkurs.mlx
└── Beispiel_Figures/      # Example figure scripts
    ├── Aliasing_Example.m
    ├── Powerspektrum.m
    ├── Topo_ChannelLocations.m
    └── STFT-video/
```

## Tutorials Overview

### Required Pre-Course Tutorials

Students must complete these tutorials independently before the block course:

- **Tutorial 1: Programmieren in MATLAB** (`Tutorial1_MATLAB.mlx`)
  - Basic MATLAB programming concepts
  - Variables, arrays, matrices
  - Control structures (if-else, for loops, while loops)
  - Plotting basics

- **Tutorial 2: Digitale Signalverarbeitung** (`Tutorial2_DigitaleSignalverarbeitung.mlx`)
  - Digital signal processing fundamentals
  - Sinusoidal waves, frequency, amplitude, phase
  - Interactive visualizations

### Optional Self-Study Tutorials

These tutorials are available for interested students who want to deepen their knowledge:

- **Tutorial 3: Datenstrukturen** (`Tutorial3_Datenstrukturen.mlx`)
  - MATLAB data structures: struct, cell arrays, tables
  - Practical examples for EEG data organization

- **Tutorial 4: Sauberer Code & Reproduzierbarkeit** (`Tutorial4_SaubererCode_Reproduzierbarkeit.mlx`)
  - Code organization and structure
  - Loops over subjects and conditions
  - Writing functions
  - Error handling and debugging

- **Tutorial 5: EEGLAB Grundlagen** (`Tutorial5_EEGLAB_Grundlagen.mlx`)
  - Introduction to EEGLAB
  - Loading and inspecting EEG data
  - Visualization (eegplot, topoplot)
  - Events and epochs
  - Basic preprocessing
  - Simple ERPs

- **Tutorial 6: Zeit-Frequenz-Analyse** (`Tutorial6_ZeitFrequenzanalyse.mlx`)
  - Time-frequency analysis concepts
  - Fourier Transform and power spectra
  - STFT and Wavelet analysis
  - Hilbert Transform for frequency band power

- **Tutorial 7: Signale, Filter und Zeit-Frequenz-Analyse** (`Tutorial7_Signale_Filter_ZeitFrequenzGrundlagen.mlx`)
  - Deep dive into signal processing
  - Sampling rate and Nyquist frequency
  - Aliasing
  - Filtering concepts
  - Time-frequency analysis fundamentals

- **Tutorial 8: Datenexport** (`Tutorial8_Datenexport.mlx`)
  - Exporting tables (CSV/TXT)
  - Saving high-resolution plots
  - MAT file storage
  - BIDS format introduction

## Language Versions

- **German**: All tutorials are available as MATLAB Live Scripts (`.mlx`) in German
- **English**: English versions are available as MATLAB scripts (`.m`) in the `Tutorials/EN/` subfolder

## Getting Started

### Prerequisites

- MATLAB (recommended: R2019b or later for Live Scripts)
- EEGLAB toolbox (included in `Praxis/eeglab2021.1/`)

### Setup

1. Clone or download this repository
2. Open MATLAB and navigate to the repository folder
3. Add EEGLAB to your MATLAB path:
   ```matlab
   addpath('Praxis/eeglab2021.1')
   eeglab
   close
   ```

### Running Tutorials

1. **German Live Scripts**: Open `.mlx` files directly in MATLAB. Click "Run" in the Live Editor tab to execute.

2. **English Scripts**: Open `.m` files from `Tutorials/EN/` folder. Convert them to Live Scripts for the correct formatting in MATLAB.

## Practice Materials

The `Praxis/` folder contains:

- **Practice Scripts** (`Praxis/files_dropbox/`): Scripts used during the block course with solution versions
- **EEG Data** (`Praxis/data/`): Sample EEG data files for practice
- **EEGLAB**: Complete EEGLAB toolbox installation

## Exercises

The `Aufgaben/` folder contains exercise assignments that students complete after Tutorials 1 and 2.

## Example Figures

The `Beispiel_Figures/` folder contains example scripts demonstrating:
- Aliasing effects
- Power spectra
- Topographic plots
- STFT visualizations