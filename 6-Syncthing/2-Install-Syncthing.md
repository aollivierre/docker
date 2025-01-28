To run Syncthing as a Docker container with persistent storage on your Ubuntu host, follow these steps:

### 1. **Create a directory for persistent storage:**
You need to create directories on the host system where Syncthing will store its configuration files and data.

```bash
mkdir -p ~/syncthing/config
mkdir -p ~/syncthing/data
```

This will create two directories:
- `config` for Syncthing’s configuration files.
- `data` for the data Syncthing will synchronize.

### 2. **Run Syncthing as a Docker container:**
You can run the Syncthing container using the `docker run` command, while mapping the created directories for persistent storage. Here’s how to do it:

```bash
sudo docker run -d \
  --name syncthing \
  -p 8384:8384 \
  -p 22000:22000 \
  -p 21027:21027/udp \
  -v ~/syncthing/config:/var/syncthing/config \
  -v ~/syncthing/data:/var/syncthing/data \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  --restart unless-stopped \
  syncthing/syncthing:latest
```

### Explanation:
- **Port Mapping**:
  - `-p 8384:8384`: Exposes the Syncthing web UI on port 8384.
  - `-p 22000:22000`: Exposes the sync service on port 22000.
  - `-p 21027:21027/udp`: Exposes the discovery service for local devices.

- **Volume Mapping**:
  - `-v ~/syncthing/config:/var/syncthing/config`: Maps the host directory `~/syncthing/config` to the container's config directory for persistent storage.
  - `-v ~/syncthing/data:/var/syncthing/data`: Maps the host directory `~/syncthing/data` to the container’s data directory.

- **User Permissions**:
  - `-e PUID=$(id -u)` and `-e PGID=$(id -g)`: Ensures the container runs with the same user and group IDs as your host user, so you won’t have permission issues accessing the files.

- **Restart Policy**:
  - `--restart unless-stopped`: Automatically restarts the container unless manually stopped.

### 3. **Access Syncthing Web UI:**
Once the container is running, you can access the Syncthing web interface by going to:

```
http://<your-server-ip>:8384
```

### 4. **Persistent Data:**
The configuration and synchronized data will now persist on your host machine under `~/syncthing/config` and `~/syncthing/data`, even if the container is restarted or recreated.

Let me know if you encounter any issues!