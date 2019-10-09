from PIL import Image
from pathlib import Path

import scipy.io as sio
import imageio
import OpenEXR
import Imath
import numpy
import os

################################################################################

# change this path according to your needs
input_directory = '/path/to/FoggySynscapes/data/demo/depth_exr/'

################################################################################

output_directory_mat = Path(input_directory.parent) / 'depth_mat'
output_directory_mat_2k = Path(input_directory.parent) / 'depth_mat-2k'

output_directory_mat.mkdir(parents=True, exist_ok=True) 
output_directory_mat_2k.mkdir(parents=True, exist_ok=True) 

output_directory_map = Path(input_directory.parent) / 'depth_map'
output_directory_map_2k = Path(input_directory.parent) / 'depth_map-2k'


file_list = os.listdir(input_directory)

new_file_list = []

for file in file_list:

    new_file_list.append(file.zfill(9))

for filename in sorted(new_file_list):

    filename = filename.lstrip('0')

    if filename.endswith(".exr"):

        file = OpenEXR.InputFile(input_directory + filename)

        dw = file.header()['dataWindow']
        size = (dw.max.x - dw.min.x + 1, dw.max.y - dw.min.y + 1)

        pixel_type = Imath.PixelType(Imath.PixelType.FLOAT)
        z = file.channel('Z', pixel_type=pixel_type)

        img = Image.frombytes("F", size, z)
        img_2k = img.resize((2048, 1024), Image.BILINEAR)

        # convert image to np array
        depth = numpy.array(img)
        depth_2k = numpy.array(img_2k)

        # apply log, otherwise most of the visualization is one color
        depth_map = numpy.log(depth)
        depth_map_2k = numpy.log(depth_2k)

        # normalize to values between 0 and 1
        depth_map = depth_map / depth_map.max()
        depth_map_2k = depth_map_2k / depth_map_2k.max()

        # invert from white incidating far away to black indicating far away
        depth_map = - depth_map + 1
        depth_map_2k = - depth_map_2k + 1

        save_path_mat = output_directory_mat + filename[:-4].zfill(5) + '.mat'
        save_path_mat_2k = output_directory_mat_2k + filename[:-4].zfill(5) + '.mat'
        
        sio.savemat(save_path_mat, {'depth': depth})
        sio.savemat(save_path_mat_2k, {'depth': depth_2k})
        
        save_path_map = output_directory_map + filename[:-4].zfill(5) + '.png'
        save_path_map_2k = output_directory_map_2k + filename[:-4].zfill(5) + '.png'

        imageio.imwrite(save_path_map, depth_map)
        imageio.imwrite(save_path_map_2k, depth_map_2k)

    else:

        continue
