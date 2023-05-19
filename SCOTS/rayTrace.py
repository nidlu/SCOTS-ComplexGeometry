
import os
import sys
import time
import json
from matplotlib.pyplot import *
from matplotlib.pyplot import imshow, savefig #debug
from math import pi
from numpy import sqrt, sin, cos, arctan, pi
from types import SimpleNamespace

from raysect.optical import World, translate, rotate,rotate_y,rotate_x, Point3D
from raysect.optical.library import RoughTitanium
from raysect.optical.material import UnitySurfaceEmitter
from raysect.optical.material import InhomogeneousVolumeEmitter
from raysect.optical.material.debug import PerfectReflectingSurface
from raysect.optical.observer import PinholeCamera, RGBPipeline2D, RGBAdaptiveSampler2D
from raysect.primitive import Box, Mesh, Sphere
from raysect.core.workflow import MulticoreEngine
from raysect.primitive import import_stl
from raysect.optical import InterpolatedSF
from raysect.optical.observer import BayerPipeline2D


TMP_CAM_X_OFFSET = 0.005

# Check if a command-line argument was provided
if len(sys.argv) < 5:
    print("Error: The path to the w0.stl file, output file path, phase value, and orientation were not provided as command-line arguments.")
    sys.exit(1)

# Get the path to the w0.stl file, the output file path, the phase value, and the orientation from the command-line arguments
stl_file_path = sys.argv[1]
output_file_path = sys.argv[2]
phase = float(sys.argv[3])
orientation = sys.argv[4].lower()

if orientation not in ["horizontal", "vertical"]:
    print("Error: The orientation must be either 'horizontal' or 'vertical'.")
    sys.exit(1)

#output_file_path = r"/mnt/c/Users/cjgn44/Google Drive/ULB/SCOTS5/rayTraceTest.png"
#phase = 0
#orientation = 'horizontal'
#stl_file_path = r"/mnt/c/Users/cjgn44/Google Drive/ULB/SCOTS5/08_05_2023_phaseAccTest/test4_lsq_manyimg/postprocessing/w0.stl"

stl_directory = os.path.dirname(stl_file_path)



# Get the directory containing the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the path to the parameters.json file
parameters_file_path = os.path.join(script_dir, 'parameters.json')
# Load parameters from JSON file
with open(parameters_file_path, 'r') as f:
    params = json.load(f)
# Scale the parameters from mm to m
scaled_params = {key: value * 0.001 for key, value in params['geom'].items()}
geom = SimpleNamespace(**scaled_params)

# Load additional parameters
aqPar = params["aqPar"]
canvasSize_px = aqPar["canvasSize_px"]
screen_m_per_px = aqPar["screen_mm_per_px"]/1000
image_m_per_px = aqPar["image_mm_per_px"]/1000
fringesOnCanvas = aqPar["fringesOnCanvas"]
scaleFactor = aqPar["imageResizingFactor"]
cameraRotX = aqPar["cameraRotX"]
cameraRotY = aqPar["cameraRotY"]
canvasSize_m = canvasSize_px*screen_m_per_px
fringes_per_m = fringesOnCanvas/canvasSize_m

class CosGlow2D(InhomogeneousVolumeEmitter):
    def emission_function(self, point, direction, spectrum, world, ray, primitive, to_local, to_world):
        spectrum = ray.new_spectrum()
        # Only emit light when z-coordinate is near the center of the thin box (i.e., on the surface of the box)
        if abs(point.z) < 1e-3:
            if orientation == "horizontal":
                spectrum.samples[:] = (sin(2 * pi * fringes_per_m * point.y + phase) + 1) / 2
            elif orientation == "vertical":
                spectrum.samples[:] = (sin(2 * pi * fringes_per_m * point.x - phase) + 1) / 2
        return spectrum


# scene
world = World()
emitter = Box(Point3D(-canvasSize_m/2, -canvasSize_m/2, -0.01), Point3D(canvasSize_m/2, canvasSize_m/2, 0.01), material=CosGlow2D(),
              parent=world, transform=translate(geom.zeroPhaseScreenX, geom.zeroPhaseScreenY, geom.zeroPhaseScreenZ))

mesh = import_stl(stl_file_path, scaling=0.001, mode='binary', parent=world,
                  transform=translate(geom.mirrorCenterX, geom.mirrorCenterY, geom.mirrorCenterZ)*rotate(0, 0, 0),
                  material=PerfectReflectingSurface())

# Calculate the FOV based on the given pixel scale and distance
distance_to_target = geom.mirrorCenterZ - geom.cameraZ
larger_dimension = max(int(1280 * scaleFactor), int(960 * scaleFactor))
fov = 2 * arctan((0.5 * larger_dimension * image_m_per_px) / -distance_to_target) * (180 / pi)

# camera
#rgb_pipeline = RGBPipeline2D(display_update_time=5)
filter_red = InterpolatedSF([100, 650, 660, 670, 680, 800], [0, 0, 1, 1, 0, 0])
filter_green = InterpolatedSF([100, 530, 540, 550, 560, 800], [0, 0, 1, 1, 0, 0])
filter_blue = InterpolatedSF([100, 480, 490, 500, 510, 800], [0, 0, 1, 1, 0, 0])

bayer = BayerPipeline2D(filter_red, filter_green, filter_blue,display_gamma=1,
                            display_unsaturated_fraction=1, name="Bayer Filter")
#sampler = RGBAdaptiveSampler2D(bayer, min_samples=50, fraction=0.2)

camera = PinholeCamera((int(1280*scaleFactor), int(960*scaleFactor)), parent=world, transform=translate(geom.cameraX+TMP_CAM_X_OFFSET, geom.cameraY, geom.cameraZ)*rotate_y(180+cameraRotY)*rotate_x(cameraRotX),
                       pipelines=[bayer])
camera.fov = fov

camera.spectral_bins = 1
camera.spectral_rays = 1
camera.pixel_samples = 20
camera.render_engine = MulticoreEngine(4)

# integration resolution
emitter.material.integrator.step = 0.05

camera.observe()
bayer.save(output_file_path)

#debug
#imshow(intensity_values, cmap='gray')  # Display the intensity values as a grayscale image
#savefig(output_file_path)  # Save the current figure to the output file


# start ray tracing
#os.nice(15)
#ion()
#timestamp = time.strftime("%Y-%m-%d_%H-%M-%S")
#for p in range(1, 2):
#    print("Rendering pass {}...".format(p))
##    camera.observe()
 #   rgb_pipeline.save("demo_volume_{}_pass_{}.png".format(timestamp, p))
 #
 #    print()

# display final result
#ioff()
#rgb_pipeline.display()
#show()