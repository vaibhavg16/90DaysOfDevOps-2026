Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment Task

Steps:

1. Launch a cloud instance (AWS EC2)

![screenshot](images/instance.png)

2. Connect via SSH

Commands:
cp /mnt/c/Users/VAIBHAV/Downloads/day08.pem .
chmod 400 day08.pem
ssh -i day08.pem ubuntu@ec2-13-247-66-233.af-south-1.compute.amazonaws.com

![screenshot](images/ssh_connect.png)

3. Install Nginx

Commands:
sudo apt-get install nginx.service
sudo systemctl start nginx
sudo systemctl status nginx

![screenshot](images/nginx.png)

4. Configure security groups for web access (port 80 by default for nginx)

By default, AWS blocks incoming traffic to Port 80 (HTTP). You need to allow it:

- In the AWS EC2 console, select your running instance.
- Click the Security tab at the bottom and click on your Security Group.
- Click Edit inbound rules.
- Add a new rule: Type: HTTP -> Port Range: 80 -> Source: Anywhere-IPv4 (0.0.0.0/0) -> Save the rules.

5. Extract and save logs to a file

i : View Nginx Logs

![screenshot](images/logs.png)

ii : Save Logs to File

![screenshot](images/logs2.png)

iii : Download Log File to Your Local Machine

Commands:
cp /mnt/c/Users/VAIBHAV/Downloads/day08.pem ~/
chmod 400 ~/day08.pem 
scp -i ~/day08.pem ubuntu@ec2-13-247-66-233.af-south-1.compute.amazonaws.com:~/nginx-logs.txt .

![screenshot](images/scp.png)

6. Verify your webpage is accessible from the internet

Browser: http://13.247.66.233/

![screenshot](images/nginx_web.png)



## Commands Used
- `ssh -i <key> ubuntu@<IP>` - Connected to the remote cloud server.
- `sudo apt update -y` - Updated package definitions.
- `sudo apt install nginx -y` - Installed the Nginx web server.
- `sudo systemctl status nginx` - Verified the status of the web server service.
- `cp /var/log/nginx/access.log ~/nginx-logs.txt` - Extracted the web server logs.

## Challenges Faced
- *Challenge:* Couldn't access the Nginx welcome page initially using the Public IP.
- *Solution:* Realized that AWS security groups block port 80 by default. Added an inbound rule to allow HTTP traffic from Anywhere (`0.0.0.0/0`).

## What I Learned
1. How to provision and connect to an AWS EC2 instance using SSH.
2. Configuring firewall/security groups to expose application ports to the public internet.
3. Managing Linux services using `systemctl`.
4. Locating and extracting application web logs for analysis.

## Why This Matters for DevOps
This exercise forms the foundational bedrock of infrastructure deployment. Setting up virtual servers, configuring access policies, mapping networking ports, and gathering execution logs are fundamental daily duties of a DevOps engineer.


