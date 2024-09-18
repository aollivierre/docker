# Generate a timestamp
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Define unique container and volume names
$containerName = "my_pwsh_container_$timestamp"
$codeVolumeName = "code_volume_$timestamp"
# $modulesVolumeName = "modules_volume_$timestamp"
$bindVolumePath = "C:/code"

# Create Docker named volumes
docker volume create --name $codeVolumeName
# docker volume create --name $modulesVolumeName

# # Construct the arguments for the docker run command
# $dockerArgs = @(
#     "run",
#     "-it",
#     "-v ${codeVolumeName}:C:/container/code",
#     # "-v ${modulesVolumeName}:C:/container/Modules",
#     "-v ${bindVolumePath}:C:/code",
#     "--name $containerName",
#     "-e SCRIPT_BASE_PATH=C:/code",
#     "-e MODULES_BASE_PATH=C:/code/Modules",
#     "my_pwsh_image_with_graphauth_20240704174151:latest pwsh -NoExit -Command Start-Service ssh-agent; Start-Service sshd"
# )

# # Run the Docker container with the constructed arguments
# Start-Process -NoNewWindow -FilePath "docker" -ArgumentList $dockerArgs



# Construct the arguments for the docker run command
$dockerArgs = @(
    "run",
    "-d",  # Run in detached mode
    "-v ${codeVolumeName}:C:/container/code",
    "-v ${bindVolumePath}:C:/code",
    "--name $containerName",
    "-e SCRIPT_BASE_PATH=C:/code",
    "-e MODULES_BASE_PATH=C:/code/Modules",
    "my_pwsh_image_with_graphauth_20240729183015:latest",
    # "mycontinerwithvscodeserverandpsextension:latest",
    "pwsh -NoExit -Command Start-Service ssh-agent; Start-Service sshd; Start-Sleep -Seconds 999999"
)

# Run the Docker container with the constructed arguments
Start-Process -NoNewWindow -FilePath "docker" -ArgumentList $dockerArgs




#     Yes, it is possible to use both bind mounts and named volumes simultaneously in a Docker container. This can be useful if you want to leverage the benefits of both methods for different parts of your container's file system.

# ### Example Docker Run Command

# Here's an example of how you can run a Docker container with both bind mounts and named volumes:

# ```sh
# # Generate a timestamp
# $timestamp = Get-Date -Format "yyyyMMddHHmmss"

# # Define unique container and volume names
# $containerName = "my_pwsh_container_$timestamp"
# $codeVolumeName = "code_volume_$timestamp"
# $modulesVolumeName = "modules_volume_$timestamp"
# $bindVolumePath = "C:/Host/Directory"

# # Create Docker named volumes
# docker volume create --name $codeVolumeName
# docker volume create --name $modulesVolumeName

# # Run the Docker container with both named volumes and a bind mount
# docker run -it `
#     -v "${codeVolumeName}:C:/code" `  # Named volume
#     -v "${modulesVolumeName}:C:/code/Modules" `  # Named volume
#     -v "${bindVolumePath}:C:/bindmount" `  # Bind mount
#     --name $containerName `
#     -e SCRIPT_BASE_PATH="C:/code" `
#     -e MODULES_BASE_PATH="C:/code/Modules" `
#     my_pwsh_image pwsh -ExecutionPolicy Bypass
# ```

# ### Explanation

# - **Named Volumes**:
#   - `-v "${codeVolumeName}:C:/code"`: Creates a named volume for the `/code` directory.
#   - `-v "${modulesVolumeName}:C:/code/Modules"`: Creates a named volume for the `/code/Modules` directory.

# - **Bind Mount**:
#   - `-v "${bindVolumePath}:C:/bindmount"`: Binds the host directory `C:/Host/Directory` to the container directory `/bindmount`.

# - **Environment Variables**:
#   - `-e SCRIPT_BASE_PATH="C:/code"`: Sets an environment variable pointing to the `/code` directory.
#   - `-e MODULES_BASE_PATH="C:/code/Modules"`: Sets an environment variable pointing to the `/code/Modules` directory.

# ### Practical Use Cases

# - **Named Volumes**: Ideal for storing persistent data managed by Docker, such as application data, databases, and configuration files.
# - **Bind Mounts**: Ideal for development, where you need to share source code or configuration files between the host and the container and want changes to be immediately reflected.

# ### Example Use Case

# Suppose you are developing an application where:
# - The source code (`C:/Host/Directory`) needs to be edited and tested frequently, so you use a bind mount for this.
# - The application generates logs and stores data in specific directories (`/code` and `/code/Modules`), and you want Docker to manage these as named volumes to ensure data persistence and manageability.

# This approach allows you to use the strengths of both types of volumes to fit your development and deployment needs. 

# ### Summary

# By combining named volumes and bind mounts, you can tailor the Docker environment to your specific requirements, leveraging the strengths of each volume type for different purposes within the same container. This flexibility makes Docker a powerful tool for both development and production environments.