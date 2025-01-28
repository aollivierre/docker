If your Debian server is running Fail2ban and you suspect that it has locked you out due to multiple failed login attempts, you can regain access by temporarily disabling Fail2ban or removing the ban on your IP address. Here are the steps you can follow:

1. **Access the Server via an Alternative Method**:
   - Use a different network or VPN to change your IP address and try SSH again.
   - If you have direct access to the server or can access it through a control panel provided by your hosting service, use it to log into the server.

2. **Unban Your IP Address**:
   - Once you have access to the server, you can unban your IP address. First, identify the jail that your IP is banned in. You can list all the current bans with:
     ```
     sudo fail2ban-client status
     ```
   - Then, check the specific jail (e.g., `sshd`) for your banned IP:
     ```
     sudo fail2ban-client status sshd
     ```
   - To unban your IP address, use:
     ```
     sudo fail2ban-client set sshd unbanip YOUR_IP_ADDRESS
     ```

3. **Restart Fail2ban**:
   - After unbanning your IP, it's a good idea to restart the Fail2ban service to ensure all changes are applied:
     ```
     sudo systemctl restart fail2ban
     ```

4. **Review Fail2ban Configuration**:
   - Check your Fail2ban configuration to ensure it's set up according to your needs. You can adjust the number of failed attempts allowed and the ban duration in the configuration files, typically located in `/etc/fail2ban`.

5. **Check Server Logs**:
   - Review the server logs (`/var/log/auth.log`) to understand why your access was denied. This can help you identify if it was indeed a wrong password or another issue.

6. **Implement Key-Based SSH Authentication**:
   - To avoid similar issues in the future, consider setting up SSH key-based authentication. It's more secure and reduces the risk of being locked out due to password issues.

Remember, Fail2ban is a crucial security tool that protects your server against brute-force attacks. While it's important to regain access if you're locked out, make sure to maintain the integrity and security of your server's Fail2ban configuration.