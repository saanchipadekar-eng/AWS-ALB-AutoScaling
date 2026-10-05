# AWS ALB + Auto Scaling Web Application

## Project Overview

This project demonstrates a highly available and scalable web application using AWS.

The application runs on Amazon EC2 instances behind an Application Load Balancer (ALB). An Auto Scaling Group manages the EC2 instances, while Amazon CloudWatch monitors CPU utilization.

## Objective

- Demonstrate ALB traffic distribution
- Host a web application on EC2
- Configure Auto Scaling
- Monitor EC2 using CloudWatch
- Demonstrate high availability

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon EC2 | Runs the web application |
| Application Load Balancer | Distributes incoming traffic |
| Auto Scaling Group | Maintains EC2 capacity |
| Target Group | Health-checks EC2 instances |
| Amazon CloudWatch | Monitors CPU utilization |
| AWS IAM | Manages permissions |
| Launch Template | Defines EC2 configuration |

## Architecture

Internet / User
  -> Application Load Balancer
  -> Target Group
  -> EC2 Instance 1 and EC2 Instance 2
  -> Auto Scaling Group
  -> CloudWatch CPU Alarm
  -> Scale-Out Policy
  -> New EC2 Instance

## Application Features

- Instance ID
- Hostname
- Private IP address
- Health status
- EC2 information
- ALB information
- Auto Scaling information
- CloudWatch information
- Refresh button

## Traffic Distribution

The ALB successfully distributed requests between the two healthy EC2 instances.

Request 1 -> i-0cca2787f7b9654be
Request 2 -> i-097ec1b59531400f0
Request 3 -> i-0cca2787f7b9654be
Request 4 -> i-097ec1b59531400f0
Request 5 -> i-0cca2787f7b9654be
Request 6 -> i-097ec1b59531400f0

## Auto Scaling Configuration

- Minimum instances: 2
- Desired instances: 2
- Maximum instances: 3
- Health check type: ELB
- Health check grace period: 60 seconds

## CloudWatch Monitoring

Alarm: AWS-ALB-AutoScaling-HighCPU
Metric: CPUUtilization
Namespace: AWS/EC2
Threshold: Greater Than 50 percent
Action: Scale-out policy

## Health Checks

Both EC2 instances were verified as Healthy and InService.
Both instances use Launch Template Version 4.

## Instance Refresh

Status: Successful
Completion: 100 percent
Instances remaining to update: 0
Minimum healthy percentage: 100 percent

## Project Workflow

1. User sends a request to the ALB.
2. ALB forwards the request to a healthy EC2 instance.
3. EC2 runs the AWS SCALE APP.
4. The application retrieves instance metadata using IMDSv2.
5. Instance information is displayed.
6. ALB distributes subsequent requests between healthy instances.
7. CloudWatch monitors CPU utilization.
8. A high CPU alarm can trigger the scale-out policy.
9. Auto Scaling can launch an additional EC2 instance.
10. The new instance is registered after passing its health check.

## Project Structure

AWS-ALB-AutoScaling/
  screenshots/
    01-alb-website.png
    02-alb-traffic-distribution.png
    03-auto-scaling-instances.png
    04-target-group-health.png
    05-cloudwatch-alarm.png
  user-data-clean.sh
  user-data.sh
  .gitignore
  README.md

## Screenshots

- ALB Web Application: screenshots/01-alb-website.png
- ALB Traffic Distribution: screenshots/02-alb-traffic-distribution.png
- Auto Scaling Instances: screenshots/03-auto-scaling-instances.png
- Target Group Health: screenshots/04-target-group-health.png
- CloudWatch Alarm: screenshots/05-cloudwatch-alarm.png

## Security Practices

- EC2 private key is excluded from GitHub.
- Sensitive deployment files are excluded using .gitignore.
- IAM permissions are controlled using an IAM policy.
- EC2 instances use IMDSv2.
- Security Groups restrict network access.
- AWS credentials are not stored in source code.

## Technologies Used

- Amazon EC2
- Application Load Balancer
- Auto Scaling
- Amazon CloudWatch
- AWS IAM
- Python
- HTML
- CSS
- JavaScript
- PowerShell
- AWS CLI
- Git and GitHub

## Learning Outcomes

I learned how to deploy applications on EC2, configure an Application Load Balancer, configure Target Groups, configure Auto Scaling, create CloudWatch alarms, configure scaling policies, perform Instance Refresh, verify target health, test load balancing, use IMDSv2, and manage AWS resources using AWS CLI.

## Conclusion

This project demonstrates how AWS services work together to provide a highly available and scalable web application. The Application Load Balancer distributes traffic across healthy EC2 instances, Auto Scaling maintains application capacity, and CloudWatch monitors system performance.

## Author

Saanchi Narendra Padekar
AWS Cloud & Data Analytics Fresher
