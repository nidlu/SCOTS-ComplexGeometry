import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# Plot the mesh of the imported STL file
def plot_mesh(mesh, save_file):
    # Extract vertices and triangles from the mesh
    vertices = mesh.data.vertex_positions
    triangles = mesh.data.triangles

    # Create a 3D plot
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    # Create a Poly3DCollection from the triangles and vertices
    poly3d = Poly3DCollection(vertices[triangles], edgecolor='k')

    # Add the Poly3DCollection to the plot
    ax.add_collection3d(poly3d)

    # Set the axis limits
    ax.set_xlim(np.min(vertices[:, 0]), np.max(vertices[:, 0]))
    ax.set_ylim(np.min(vertices[:, 1]), np.max(vertices[:, 1]))
    ax.set_zlim(np.min(vertices[:, 2]), np.max(vertices[:, 2]))

    # Set the axis labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    # Save the plot to a file
    plt.savefig(save_file)
    plt.close(fig)

# Plot the position of the camera and the emitter
def plot_camera_and_emitter(camera, emitter, save_file):
    fig, ax = plt.subplots(subplot_kw={'projection': '3d'})

    # Plot the camera position
    ax.scatter(camera.transform.x, camera.transform.y, camera.transform.z, c='r', marker='o', label='Camera')

    # Plot the emitter center position
    emitter_center = (emitter.bounds.lower + emitter.bounds.upper) / 2
    ax.scatter(emitter_center.x, emitter_center.y, emitter_center.z, c='b', marker='^', label='Emitter')

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    # Show the legend
    ax.legend()

    # Save the plot to a file
    plt.savefig(save_file)
    plt.close(fig)

# Plot a slice of the emission function
def plot_emission_function(material, save_file):
    x = np.linspace(-canvasSize_mm / 2, canvasSize_mm / 2, 1000)
    y = np.linspace(-canvasSize_mm / 2, canvasSize_mm / 2, 1000)
    X, Y = np.meshgrid(x, y)
    Z = (np.sin(2 * np.pi * fringes_per_unit_length * Y + np.pi) + 1) / 2

    fig, ax = plt.subplots()
    c = ax.pcolormesh(X, Y, Z, cmap='viridis', shading='auto')

    ax.set_xlabel('X')
    ax.set_ylabel('Y')

    fig.colorbar(c, ax=ax)

    # Save the plot to a file
    plt.savefig(save_file)
    plt.close(fig)

# Save the plots
plot_mesh(mesh, "mesh_plot.png")
plot_camera_and_emitter(camera, emitter, "camera_emitter_plot.png")
plot_emission_function(emitter.material, "emission_function_plot.png")
