#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <vnc_display_number>"
    exit 1
fi

USERNAME="$1"
DISPLAY_NUM="$2"
SERVICE_NAME="vnc-${USERNAME}.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"

# Create systemd service file
echo "Creating VNC service file at $SERVICE_PATH..."

sudo bash -c "cat > $SERVICE_PATH" <<EOF
[Unit]
Description=VNC Server for $USERNAME on display :$DISPLAY_NUM
After=network.target

[Service]
Type=forking
User=$USERNAME
WorkingDirectory=/home/$USERNAME
PIDFile=/home/$USERNAME/.vnc/%H:$DISPLAY_NUM.pid
ExecStartPre=-/usr/bin/vncserver -kill :$DISPLAY_NUM > /dev/null 2>&1
ExecStart=/usr/bin/vncserver :$DISPLAY_NUM -geometry 1280x800 -depth 24
ExecStop=/usr/bin/vncserver -kill :$DISPLAY_NUM

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling $SERVICE_NAME..."
sudo systemctl enable "$SERVICE_NAME"

echo "Starting $SERVICE_NAME..."
sudo systemctl start "$SERVICE_NAME"

echo "✅ VNC service for $USERNAME on :$DISPLAY_NUM has been created and started."
