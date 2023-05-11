# SCOTS-ComplexGeometry
This project extends the Software Configurable Optical Testing System (SCOTS), originally designed for circular pupils. The changes presented here enable application to complex and unconventional geometries, with a focus on large deflection, segmented petal reflectors.

SCOTS uses an imaging camera, a test specimen (spherical mirror), and a computer monitor to measure mirror shape based on the distortion of a known phase screen displayed on the monitor and reflected in the mirror. The system enables precise identification of geometric vectors for each mirror pixel.

This repository contains MATLAB implementations. The alterations are particularly designed for testing and characterizing reflectors with complex geometries. The software calculates the slope map of a reflector and integrates the map to determine the mirror's shape.

## System Operation
- The system displays a known phase screen on a monitor.
- The image of the phase screen is reflected in the mirror and acquired by the camera.
- The distortion of the phase screen corresponds to slope measurements in the reflector, allowing the reconstruction of the mirror shape from the acquired camera image.
- The software computes geometric vectors for each mirror pixel from the captured images.
- The slope map of the reflector is calculated, and the mirror shape is integrated from the slope data.

## Licensing
This project is licensed under the GNU General Public License v3.0. See the `LICENSE` file for the full license text.

This project also includes code from other projects:

- Code by Stephen Cobeldick is licensed under a BSD 3-Clause License.
- Code by Firman is licensed under a BSD 3-Clause License.

Please respect the licenses of all included software. The relevant licenses are in the respective subfolders.

For a more detailed explanation of the system operation, see the documentation included in the repository.
