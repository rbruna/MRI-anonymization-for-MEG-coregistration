# Improved MRI anonymization (de-facing) for MEG coregistration

This repository contains the code for the aforemention research work.


# Prerequisites I - External toolboxes

The code here requires (and corrects) several publicly avaiable toolboxes.

The required toolboxes are:
* NIfTI tools (https://es.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image).
* SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/).
* OSL (https://ohba-analysis.github.io/osl-docs/).
* NotBoxPlot (https://es.mathworks.com/matlabcentral/fileexchange/26508-notboxplot).

Please, note that OSL requires SPM12 to be placed in a very specific folder. The recommended placing for these and according to the following tree:

```
osl/
   | osl-core/
   | SPM12/
toolboxes/
         | nifti/
         | notboxplots/
```  

Other configuration might be functional, but we cannot guarantee it.

Nota that other toolboxes might be requiered (e.g., OSL requires FSL to work).


# Prerequisites II - Data

To replicate the results in the paper, you will require the BioFIND data set. Unfortunately, due to privacy issues (thus the need of this work) we cannot share this data publicly. We can, however, share this data in the context of a collaboration / data sharing agreement.

Todo so, you must contact us directly.

The deanonimyzed data can be access through the DPUK sytstem: https://portal.dementiasplatform.uk/Apply


# Repository structure

The work developed in the paper has two differentiated parts.

## Experiment 1

This is a behavioral experiment where several participants were asked to match individual's MRI images to their front-face pictures.

Data and code for this experiment is provided in *Code for experiment 1*.

## Expriment 2

This is an experiment studying the effect of defacing in the MRI-MEG coregistration, using the data in the BioFIND dataset.

Data for this experiment can be obtained under a data sharing agreement (se above). Code for this experiment is provided in the folder *Code for experiments 2 and 3*.

The scripts in this folder related to this experiment are:
1 s0_copyMRIs.m creates the file structure for the rest of the codes.
2 s1_resliceMRIs.m reslices the images (with different levels of defacing) in 1-mm3 isitropic images with an identity voxel-to-real-world transformation matrix.
3 s2_coregister.m coregisters the MRI image (from the fiducials or the scalp points, depending on the configuration) to the MEG head points.
4 s3a_statsExp2.m calculates the statistics for the different defacing methods.
5 s3b_plotsExp2.m creates the figures in the paper.

## Experiment 3

This is an experiment studying the effect of defacing in the definition of the inner skull surface for MEG forward modeling, using the data in the BioFIND dataset.

Data for this experiment can be obtained under a data sharing agreement (se above). Code for this experiment is provided in the folder *Code for experiments 2 and 3*.

The scripts in this folder related to this experiment are:
1 s0_copyMRIs.m creates the file structure for the rest of the codes.
2 s1_resliceMRIs.m reslices the images (with different levels of defacing) in 1-mm3 isitropic images with an identity voxel-to-real-world transformation matrix.
3 s2_coregister.m generates (when configured to use SPM) the inner skull, outer skull and scalp meshes for forward modelling.
4 s4a_summaryExp3.m generates a summary of the error in the creation of the inner skull meshes.
5 s4b_statsExp3.m calculates the statistics for the different defacing methods.
6 s4c_plotsExp3.m creates the figures in the paper.
