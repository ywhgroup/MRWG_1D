# MRWG_1D

## Requirements
Matlab 2022b or later. Earlier versions might work but have not been verified.

RETICOLO - rigourous coupled wave analysis (RCWA) solver. Can be downloaded from [RETICOLO](https://www.lp2n.institutoptique.fr/equipes-de-recherche-du-lp2n/light-complex-nanostructures). Copy the folder `reticolo_allege` into the working directory.

## Quick Start
Run `RunOpt_1DMRWG.m` with default parameters. The example optimization should begin immediately if all files have been installed correctly.

In `RunOpt_1DMRWG.m`, define the optimization parameters, such as blur radius, maximum iteration limits for fmincon, optimization minimum step, and the upper and lower bounds for the target optimization structure (e. g., 0~1).

## Grating parameters and optimization
The `FoM_and_Grad.m` defines the MRWG parameters, such as waveguide layer thickness (Hw), grating layer thickness (Hg), materials' refractive index and optimization function.

The `%% Blur function & contrast function` section in `FoM_and_Grad.m` is used to define Rho2 and Rho3. The optimization contrast can be controlled by adjusting “beta” and “cutoff”.

The `%% Reticolo 1D structure definition` section in `FoM_and_Grad.m` is used to convert the MRWG structure into the RETICOLO format. For detailed RETICOLO syntax, please refer to the following the paper [RETICOLO software for grating analysis](https://arxiv.org/abs/2101.00901).

The `%% Forward calculation, FoM` section in `FoM_and_Grad.m` uses RETICOLO to calculate the MRWG Efficiency (Abs_Efficiency) and the forward electric field (ForwardField).

The `%% Adjoint calculation, gradient of FoM` section in `FoM_and_Grad.m` uses RETICOLO to calculate the Adjoint electric field (AdjointField). Then, based on Eq. S3, it calculates ∂FoM/∂Rho3 (Gradient2) and uses the chain rule to backpropagate ∂FoM/∂Rho1 (Gradient) to Rho1 (PatternIn). fmincon optimizes Rho1 (PatternIn) according to the   (Gradient) calculated in `FoM_and_Grad.m`.

## Citation
If you use this code for your research, please cite:

[Topology Optimization Enables High-Q Metasurface for Color Selectivity](https://doi.org/10.1021/acs.nanolett.4c01858) <br>
Huan-Teng Su, Lu-Yun Wang, Chih-Yao Hsu, Yun-Chien Wu, Chang-Yi Lin, Shu-Ming Chang, and Yao-Wei Huang
