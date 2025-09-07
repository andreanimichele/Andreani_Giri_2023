# Energy Inflation Analysis

This repository contains R and MATLAB scripts to download, process, and analyze **energy inflation** data for major economies.

## Workflow

1. **get_data.R (`get_data.R`)**
   - Downloads monthly energy inflation data from [FRED](https://fred.stlouisfed.org/) for France, Germany, Italy, Japan, the UK, and the US.
   - Merges datasets by date and calculates **year-over-year (YoY)** growth.
   - Saves processed data to `data/data.xlsx`.

2. **results.m (`results.m`)**
   - Loads `data/data.xlsx` with YoY energy inflation.
   - Plots time series charts for each country.
   - Performs **wavelet power spectrum (WPS) analysis**:
     - Computes continuous wavelet transforms.
     - Extracts local maxima (ridges) and global wavelet power spectra (GWPS).
     - Adds significance contours and cone of influence (COI).
   - Saves figures to the `results` folder (`.eps` files).

## Outputs

- `data/data.xlsx` – YoY energy inflation data.
- `results/EI_<country>.eps` – Time series charts.
- `results/PS_<country>.eps` – Wavelet power spectra.
- `results/GWPS_<country>.eps` – Global wavelet power spectra.

## References

- Andreani, M., & Giri, F. (2023). *Not a short-run noise! The low-frequency volatility of energy inflation*. Finance Research Letters, 51, 103477.