9. **Create Folders for Vaultwarden**:
   - `mkdir -p /opt/vw`
     - Creates a directory for Vaultwarden data (`/opt/vw`).
   - `mkdir -p /opt/vw/docker`
     - Creates a subdirectory for the Docker Compose file.

10. **Create and Edit Docker Compose File**:
    - `nano /opt/vw/docker/docker-compose.yaml`
      - Opens the nano text editor to create and edit the Docker Compose file for Vaultwarden.

11. **Start Vaultwarden Using Docker Compose**:
    - `cd /opt/vw/docker/`
    - `docker compose up -d`
      - Starts the Vaultwarden service in detached mode using Docker Compose.

12. **Check Vaultwarden Data Directory**:
    - `ls /opt/vw`
      - Lists the contents of the Vaultwarden data directory to verify the installation.

These commands collectively cover the installation and initial setup of Docker and Docker Compose, preparation for running Vaultwarden, and the basic configuration of the Vaultwarden service.