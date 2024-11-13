#!/bin/sh

# Set the correct password
PASSWORD="1234"

# Create necessary directories
mkdir -p /etc/nodogsplash/htdocs

# Backup existing configuration file
cp /etc/nodogsplash/nodogsplash.conf /etc/nodogsplash/nodogsplash.conf.backup

# Write new configuration file
cat > /etc/nodogsplash/nodogsplash.conf << 'EOF'
# NoDogSplash Configuration File
GatewayInterface br-lan
GatewayAddress 192.168.8.1
GatewayPort 2050

# Debugging
DebugLevel 2
MaxClients 250

# Splash Page Settings
WebRoot /etc/nodogsplash/htdocs
SplashPage splash.html

# Authentication Settings
AuthIdleTimeout 0
ClientForceTimeout 0
ClientIdleTimeout 0
CheckInterval 30

# Firewall Rules
FirewallRuleSet authenticated-users {
    FirewallRule allow all
}

FirewallRuleSet preauthenticated-users {
    FirewallRule allow tcp port 53
    FirewallRule allow udp port 53
    FirewallRule allow tcp port 80
    FirewallRule allow tcp port 443
}

FirewallRuleSet users-to-router {
    FirewallRule allow tcp port 53
    FirewallRule allow udp port 53
    FirewallRule allow tcp port 80
    FirewallRule allow tcp port 443
}

# Logging
EnableDebug 1
LogLevel 7
SyslogFacility LOG_LOCAL0
EOF

# Write the splash page with JavaScript password validation
cat > /etc/nodogsplash/htdocs/splash.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wi-Fi Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f5f5f5;
        }
        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 90%;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 1.5rem;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #666;
        }
        input[type="password"] {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 0.75rem;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
        }
        button:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: #dc3545;
            margin-top: 0.5rem;
            display: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Wi-Fi Login</h1>
        <form method="GET" action="\$authaction">
            <input type="hidden" name="tok" value="\$tok">
            <input type="hidden" name="redir" value="\$redir">
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <div id="errorMessage" class="error-message">Invalid password. Please try again.</div>
            </div>
            <button type="submit">Connect</button>
        </form>
    </div>

    <script>
        document.querySelector("form").addEventListener("submit", function(event) {
            const inputPassword = document.getElementById("password").value;
            const correctPassword = "${PASSWORD}"; // Password validation

            if (inputPassword !== correctPassword) {
                event.preventDefault(); // Prevent form submission
                document.getElementById("errorMessage").style.display = "block";
                document.getElementById("errorMessage").textContent = "Invalid password. Please try again.";
            }
        });
    </script>
</body>
</html>
EOF

# Set permissions
chmod 755 /etc/nodogsplash/htdocs/splash.html
chmod 644 /etc/nodogsplash/nodogsplash.conf

# Restart NoDogSplash
/etc/init.d/nodogsplash stop
sleep 2
/etc/init.d/nodogsplash start
