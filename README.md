# flywheel/spm-motion-correction

SPM Motion Correction.

## Inputs
The input to this Gear is a NIfTI file.

```bash
# File can be gzipped or not.
22163_16_1.nii.gz
```

## Outputs
Motion corrected outputs, including the input file.

```bash
22163_16_1.mat
22163_16_1.nii
mean22163_16_1.nii
rp_22163_16_1.txt
```

## Example Usage/Testing

To run/test this Gear you will need to:
1. Download the Flywheel CLI and login to your Flywheel Instance 
2. Build the Docker image 
3. Execute the Gear using the Flywheel CLI


#### 1. Download the Flywheel CLI and login
For instruction on dowloading the CLI vist: https://docs.flywheel.io/hc/en-us/articles/360008162214-Installing-the-Command-Line-Interface-CLI-

Once you have the CLI, you can login:
```bash
fw login <your_flywheel_api_key>
```

#### 2. Compile the MATLAB SAE
___Important note:__ This code requires SPM, if you have not already downloaded a compiled version of SPM (or compiled it yourself) now is the time!_ 

This Gear runs a Matlab Executable via the Matlab Compiler Runtime, which is built into the base image. _Note that the image uses MCR v97 (Matlabr2019b)_ - this MCR versions used to maintain Docker image compatibility with the other tools.

You can make changes to the [source code](src/spm_motion_correction_build.m). Each time you do that, you will need to compile the [executable](src/bin) and re-build the Docker image. 

In order to compile the Matlab executable you can use the provided [`.m`](src/spm_motion_correction_build.m) file (you need to use Matlabr2019b (with the MATLAB Compiler) for the binary to be compatible with the [Docker image](Dockerfile) we generate here). 

The [`spm_motion_correction_build.m`](src/spm_motion_correction_build.m) file contains all the required instruction to compile the binary. 

You can run the code from the command line like so:
```bash
/<path_to_your_Matlabr2019b_binary> -nodesktop -r 'spm_motion_correction_build.m'
```

If you already have your Matlab2019b terminal open, you can simply run [the code](src/spm_motion_correction_build.m):
```Matlab
spm_motion_correction_build(<path_to_spm>);

```


#### 3. Build the image with Docker
```#bash
git clone https://github.com/flywheel-apps/spm-motion-correction
docker build -t flywheel/spm-motion-correction:1.0.0
```
___Important note:__ The version (`1.0.0` in the example above) should be read from the `version` key within [manifest.json](manifest.json) file._

#### 3. Run the Gear locally with the test data
```bash
fw gear local --nifti ./testdata/22163_16_1.nii.gz

```
Example output:

```
lmperry@warrior:/Users/lmperry/spm-motion-correction:$ fw gear local --nifti ./testdata/22163_16_1.nii.gz

------------------------------------------------------------------------
15-Dec-2020 17:41:15 - Running job #1
------------------------------------------------------------------------
15-Dec-2020 17:41:15 - Running 'Realign: Estimate & Reslice'

SPM12: spm_realign (v7141)                         17:41:15 - 15/12/2020
========================================================================
Completed                               :          17:41:45 - 15/12/2020

SPM12: spm_reslice (v7141)                         17:41:45 - 15/12/2020
========================================================================
Completed                               :          17:42:27 - 15/12/2020
15-Dec-2020 17:42:27 - Done    'Realign: Estimate & Reslice'
15-Dec-2020 17:42:27 - Done

Complete!


```

