This repository contains the R and MATLAB codes required to replicate the results presented in the paper:

**Title:** Not a short-run noise! The low-frequency volatility of energy inflation  
**Authors:** Michele Andreani, Federico Giri  
**Journal:** Finance Research Letters, 2023, Volume 51, 103477

---

## Requirements

- **R Version:** Scripts have been tested on R 4.3.0. Ensure that the following packages are installed:  
  - `data.table`  
  - `readxl`  
  - `writexl`  
  - `lubridate`

- **MATLAB Version:** MATLAB 9.13.0.2126072 (R2022b) Update 3 or compatible version.  

- **Toolboxes:** No additional MATLAB toolboxes are strictly required, though your system should support standard plotting and matrix operations. The wavelet analysis uses custom scripts included in this repository.

---

## Usage

To ensure smooth operation, use relative paths when running the scripts.

### How to Use

1. **Clone the Repository:**  
   - Clone this repository to your local machine.

2. **R Script: `r_script.R`**  
   - Downloads monthly energy inflation data from FRED for France, Germany, Italy, Japan, the UK, and the US.  
   - Merges the datasets by `observation_date` and computes **year-over-year (YoY)** growth.  
   - Saves processed data to `data/data.xlsx`.

3. **MATLAB Script: `matlab_script.m`**  
   - Loads `data/data.xlsx` containing YoY energy inflation.  
   - Generates time series charts for each country (`EI_<country>.eps`).  
   - Performs **wavelet power spectrum (WPS) analysis**:
     - Computes continuous wavelet transforms.  
     - Identifies local maxima (ridges) in the power spectrum.  
     - Calculates Global Wavelet Power Spectrum (GWPS).  
     - Adds significance contours and cone of influence (COI).  
   - Saves all figures to the `results` folder in `.eps` format.

4. **Output:**  
   - `data/data.xlsx` – Processed YoY energy inflation data.  
   - `results/EI_<country>.eps` – Time series charts.  
   - `results/PS_<country>.eps` – Wavelet power spectra.  
   - `results/GWPS_<country>.eps` – Global wavelet power spectra.

## Citation

Please cite the paper as follows:

Andreani, M., & Giri, F. (2023). *Not a short-run noise! The low-frequency volatility of energy inflation.* Finance Research Letters, 51, 103477.  