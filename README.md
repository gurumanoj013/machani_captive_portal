# Wi-Fi Captive Portal Setup with NoDogSplash

This guide will walk you through setting up a Wi-Fi captive portal using NoDogSplash on an OpenWrt-supported router. A captive portal allows you to prompt users for authentication, showing a login page when they connect to your Wi-Fi network.

## Requirements

- A Wi-Fi router with OpenWrt support (compatible with NoDogSplash).
- Access to the router via SSH.
- Basic knowledge of Linux commands.

## Prerequisites

- Ensure your router is running OpenWrt.
- Connect to your router via SSH. You can typically connect by running:
    ``` bash
    ssh root@<router_ip_address>
    ```
    for example:
    ``` bash
    ssh root@<192.168.8.1>
    ```

## Installation Steps

1. Update Packages and Install NoDogSplash

    ``` bash
    opkg update
    opkg install nodogsplash
    ```

2. Set Up the Directory Structure. Create directories and files for NoDogSplash:
    
    ``` bash
    mkdir -p /etc/nodogsplash/htdocs
    touch /etc/nodogsplash/htdocs/splash.html
    touch /etc/nodogsplash/nodogsplash.conf
    ```

3. Set permissions:

    ``` bash
    chmod 755 /etc/nodogsplash/htdocs/splash.html
    chmod 644 /etc/nodogsplash/nodogsplash.conf
    ```

4. Create the Log Directory

    ``` bash
    mkdir -p /var/log
    touch /var/log/nodogsplash.log
    chmod 644 /var/log/nodogsplash.log
    ```

5. Configure NoDogSplash

    - Create a setup script file to configure NoDogSplash:

    Option 1: Manually create and edit setup_nodogsplash.sh:
    ``` bash
    nano /root/setup_nodogsplash.sh
    ```
    Then, copy the contents of the provided [setup_nodogsplash.sh](setup_nodogsplash.sh) file into this script.

    Option 2: Directly copy the provided [setup_nodogsplash.sh](setup_nodogsplash.sh) file to /root/ on your router.

6. Make the Script Executable

    ``` bash
    chmod +x /root/setup_nodogsplash.sh
    ```

7. Run the Script. Execute the setup script to apply configurations:
    
    ``` bash
    /root/setup_nodogsplash.sh
    ```

    This will complete the setup and enable NoDogSplash on your OpenWrt router.

8. Captive Portal Access

From your device, Connect to the router. And then the captive portal will open. The current captive portal password is 1234.