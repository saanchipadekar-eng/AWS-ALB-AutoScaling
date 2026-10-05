#!/bin/bash

set -e

mkdir -p /opt/aws-scale-app

cat > /opt/aws-scale-app/server.py <<'PYTHON'
#!/usr/bin/env python3

import http.server
import socketserver
import urllib.request

PORT = 80


def get_metadata(path):
    try:
        token_request = urllib.request.Request(
            "http://169.254.169.254/latest/api/token",
            method="PUT",
            headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
        )

        with urllib.request.urlopen(token_request, timeout=2) as response:
            token = response.read().decode()

        request = urllib.request.Request(
            "http://169.254.169.254/latest/meta-data/" + path,
            headers={"X-aws-ec2-metadata-token": token}
        )

        with urllib.request.urlopen(request, timeout=2) as response:
            return response.read().decode()

    except Exception:
        return "Unavailable"


class AWSScaleHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):

        if self.path != "/":
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"Not Found")
            return

        instance_id = get_metadata("instance-id")
        hostname = get_metadata("local-hostname")
        private_ip = get_metadata("local-ipv4")

        html = f"""
<!DOCTYPE html>
<html>
<head>
    <title>AWS SCALE APP</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        * {{
            box-sizing: border-box;
        }}

        body {{
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }}

        .header {{
            background: white;
            padding: 25px 40px;
            border-bottom: 1px solid #e5e7eb;
        }}

        .header h1 {{
            margin: 0;
            font-size: 30px;
        }}

        .header p {{
            margin: 8px 0 0;
            color: #6b7280;
        }}

        .container {{
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }}

        .server-card {{
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }}

        .server-card h2 {{
            margin-top: 0;
        }}

        .status {{
            display: inline-block;
            padding: 8px 14px;
            border-radius: 20px;
            background: #dcfce7;
            color: #166534;
            font-weight: bold;
        }}

        .info {{
            margin-top: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 15px;
        }}

        .info-box {{
            background: #f8fafc;
            border-radius: 10px;
            padding: 18px;
        }}

        .label {{
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 7px;
        }}

        .value {{
            font-weight: bold;
            word-break: break-all;
        }}

        .services {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }}

        .service {{
            background: white;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.06);
        }}

        .service h3 {{
            margin-top: 0;
        }}

        .service p {{
            color: #6b7280;
            line-height: 1.5;
        }}

        .refresh {{
            display: inline-block;
            margin-top: 20px;
            padding: 12px 20px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }}

        .refresh:hover {{
            background: #1d4ed8;
        }}

        footer {{
            text-align: center;
            color: #6b7280;
            padding: 30px;
        }}
    </style>
</head>

<body>

<div class="header">
    <h1>AWS SCALE APP</h1>
    <p>Scalable Web Application using Application Load Balancer & Auto Scaling</p>
</div>

<div class="container">

    <div class="server-card">
        <h2>Current Server</h2>

        <span class="status">Healthy</span>

        <div class="info">

            <div class="info-box">
                <div class="label">Instance ID</div>
                <div class="value">{instance_id}</div>
            </div>

            <div class="info-box">
                <div class="label">Hostname</div>
                <div class="value">{hostname}</div>
            </div>

            <div class="info-box">
                <div class="label">Private IP</div>
                <div class="value">{private_ip}</div>
            </div>

        </div>

        <a class="refresh" href="/">Refresh Page</a>
    </div>

    <div class="services">

        <div class="service">
            <h3>EC2</h3>
            <p>Provides the virtual servers running the web application.</p>
        </div>

        <div class="service">
            <h3>Application Load Balancer</h3>
            <p>Distributes incoming user traffic across healthy EC2 instances.</p>
        </div>

        <div class="service">
            <h3>Auto Scaling</h3>
            <p>Automatically maintains the required number of EC2 instances.</p>
        </div>

        <div class="service">
            <h3>CloudWatch</h3>
            <p>Monitors application and instance performance metrics.</p>
        </div>

    </div>

</div>

<footer>
    AWS Cloud Capstone Project
</footer>

</body>
</html>
"""

        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(html.encode("utf-8"))


class ReusableTCPServer(socketserver.TCPServer):
    allow_reuse_address = True


with ReusableTCPServer(("0.0.0.0", PORT), AWSScaleHandler) as server:
    print("AWS SCALE APP running on port 80")
    server.serve_forever()
PYTHON

cat > /etc/systemd/system/aws-scale-app.service <<'SERVICE'
[Unit]
Description=AWS Scale Application
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/aws-scale-app/server.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable aws-scale-app.service
systemctl restart aws-scale-app.service
