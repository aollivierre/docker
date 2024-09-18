docker volume create portainer_data

docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v portainer_data:C:\data -v \\.\pipe\docker_engine:\\.\pipe\docker_engine portainer/portainer-ce:latest



# Yes, you can install Portainer without using WSL2. You can install and run Portainer directly on Docker for Windows, which works with Windows containers. Here’s how to do it:

# ### Steps to Install Portainer on Docker for Windows

# 1. **Install Docker Desktop**
#    - **Download and Install Docker Desktop** from the [Docker website](https://www.docker.com/products/docker-desktop).
#    - **Enable Windows Containers**:
#      - By default, Docker Desktop runs Linux containers. To switch to Windows containers, right-click the Docker icon in the system tray and select "Switch to Windows containers".

# 2. **Create a Volume for Portainer Data**
#    - Open PowerShell or Command Prompt and create a volume for Portainer data:
#      ```sh
#      docker volume create portainer_data
#      ```

# 3. **Run Portainer**
#    - Use the following command to run Portainer in a Docker container:
#      ```sh
#      docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v portainer_data:C:\data -v \\.\pipe\docker_engine:\\.\pipe\docker_engine portainer/portainer-ce:latest
#      ```

# 4. **Access Portainer**
#    - Open your web browser and navigate to `https://localhost:9443`.
#    - Follow the setup instructions to complete the installation and configure your environment.

# ### Explanation of Commands
# - `docker volume create portainer_data`: Creates a Docker volume named `portainer_data` to store Portainer data persistently.
# - `docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v portainer_data:C:\data -v \\.\pipe\docker_engine:\\.\pipe\docker_engine portainer/portainer-ce:latest`: Runs the Portainer container, exposing ports 8000 and 9443, and mounting the Docker engine's named pipe and the Portainer data volume.

# ### Additional Tips
# - **Ensure Docker Desktop is running**: Before running the commands, make sure Docker Desktop is up and running.
# - **Switch back to Linux containers**: If you need to use Linux containers later, you can switch back by right-clicking the Docker icon in the system tray and selecting "Switch to Linux containers".

# ### Resources
# - [Portainer Documentation](https://docs.portainer.io/v/ce-2.11/installation/docker/linux)
# - [Docker Desktop Documentation](https://docs.docker.com/desktop/windows/install/)

# By following these steps, you can install and run Portainer on Docker for Windows without needing WSL2, allowing you to manage your Docker environment through a graphical interface.