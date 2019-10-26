## Semantic Understanding of Foggy Scenes with Purely Synthetic Data

Forked from [github.com/sakaridis/fog_simulation-SFSU_synthetic][foggy_cityscapes_code].  
Adapted by [Martin Hahner][profile] at the Computer Vision Lab of ETH Zurich.


### Introduction

This is the source code we used in our ITSC 2019 paper titled  
[**Semantic Understanding of Foggy Scenes with Purely Synthetic Data**][website],  
to create ***Foggy Synscapes***, a foggy version of the original [*Synscapes*][synscapes] dataset.  

<img src="https://github.com/MartinHahner88/FoggySynscapes/blob/master/data/readme/preview.gif" alt="foggy_images" width="300"/>  

The pipeline computes transmittance maps,  
which can be combined with the original clear-weather image  
to obtain foggy versions of the clear-weather image.


### Pipeline Overview

<img src="https://github.com/MartinHahner88/FoggySynscapes/blob/master/data/readme/pipeline.png" alt="pipeline"/>


### Getting Started

This demo runs our fog simulation pipeline on an example clear-weather image from *Synscapes* and writes the results to `./output/demo/`. 


#### Requirements

-  **MATLAB**  
    The code has been developed in MATLAB R2018b and tested in MATLAB 2019a, too.


#### How to run the demo    

1. Clone this repository
   ```
   git clone https://github.com/MartinHahner88/FoggySynscapes.git
   ```
2. Go to MATLAB's Command Window and assign `FOG_SIMULATION_ROOT` to the path you have cloned this repository into
   ```
   FOG_SIMULATION_ROOT = '/path/to/FoggySynscapes';
   ```
3. Change MATLAB's current folder
   ```
   cd(fullfile(FOG_SIMULATION_ROOT, 'source'));
   ```
4. Run [Demo.m](source/Demo.m)
   ```
   Demo;
   ```


### Generating *Foggy Synscapes* all by yourself

Due to the [license agreement][synscapes_license] of the [*Synscapes*][synscapes] dataset,  
we unfortunatelly cannot directly distribute ***Foggy Synscapes***.  

**But** if you follow the instructions below, you can reproduce ***Foggy Synscapes*** all by yourself. \*  

\* given you have access to the original [*Synscapes*][synscapes] dataset


#### Requirements

-  ***Synscapes***  
    You need the original dataset as a starting point.

-  **Python**  
    The code has been developed and tested using Python 3.7.4.

-  **MATLAB**  
    The code has been developed in MATLAB R2018b and tested in MATLAB 2019a, too.


#### How to reproduce *Foggy Synscapes*:

1. Request the original [*Synscapes*][synscapes] dataset by sending a kind [email to the authors][synscapes_mail].

2. Then you need to convert the *.exr* depth files provided by the *Synscapes* dataset to *.mat* depth files that are compatible to our fog simulation pipeline. You can do this for example by using the provided [exr_to_mat.py](source/Depth_processing/exr_to_mat.py) python script.
   
3. Finally, you can modify [FoggySynscapes.m](source/FoggySynscapes.m) according to your needs and generate your own version of   
***Foggy Synscapes***.

**Note:** In our paper we used *beta* values of [0.005, 0.01, 0.02, 0.03, 0.06].
  

### Citations

If you use our work, please cite our [publication][publication] and the [Synscapes White Paper][synscapes_paper]:
```
@inproceedings{FoggySynscapes,
  author    = {Hahner, Martin and Dai, Dengxin and Sakaridis, Christos and Zaech, Jan-Nico and Van Gool, Luc},
  title     = {Semantic Understanding of Foggy Scenes with Purely Synthetic Data},
  booktitle = {Proceedings of the 22nd IEEE International Conference on Intelligent Transportation Systems}, 
  series    = {IEEE ITSC 2019},
  year      = {2019},
  month     = {Oct}
}

@article{Synscapes,
    author    = {Magnus Wrenninge and Jonas Unger},
    title     = {Synscapes: A Photorealistic Synthetic Dataset for Street Scene Parsing},
    url       = {http://arxiv.org/abs/1810.08705},
    year      = {2018},
    month     = {Oct}
}
```


### License

Our fog simulation pipeline is made available for *non-commercial use* only.  
For details, please refer to the [license agreement](LICENSE.txt).


### Contact

Martin Hahner  
martin.hahner[at]vision.ee.ethz.ch  
https://www.trace.ethz.ch/foggy_synscapes


[website]: <https://www.trace.ethz.ch/foggy_synscapes>
[profile]: <https://www.trace.ethz.ch/team/members/martin.html>
[publication]: <https://www.trace.ethz.ch/publications/2019/foggy_synscapes/Semantic_Understanding_of_Foggy_Scenes_with_Purely_Synthetic_Data.pdf>

[foggy_cityscapes_code]: <https://github.com/sakaridis/fog_simulation-SFSU_synthetic>

[synscapes]: <https://7dlabs.com/synscapes-overview>
[synscapes_mail]: <mailto:synscapes@7dlabs.com>
[synscapes_license]: <https://7dlabs.com/synscapes-license>
[synscapes_paper]: <https://7dlabs.com/synscapes-white-paper>
