DevOps Implementation for Internship Management System

&#x20;

DevOps Team Responsibilities

&#x20;The DevOps team works closely with developers, testers, and project managers throughout the project lifecycle.

&#x20;

Responsibilities include:

Source Code Management

&#x20;Create and manage GitHub repositories

Define branching strategy

Protect important branches

Enable Pull Request reviews

Configure GitHub Secrets



CI/CD Automation

Whenever developers push code

Checkout source code

Install dependencies

Build application

Execute unit tests

Build Docker image

Tag image with version

Push image to Amazon ECR

Update Kubernetes manifests

Deploy to Amazon EKS



**Infrastructure Management**



AWS EC2 – Hosts the application

AWS VPC - Virtual Private cloud

AWS S3 – Stores static files, certificates, and uploaded documents

AWS RDS (MySQL/PostgreSQL) – Stores application data

AWS IAM – Manages user permissions and access

AWS CloudWatch – Monitors server health and application performance

AWS Elastic Load Balancer – Distributes traffic between servers


**DevOps Workflow**



Developer

&#x20;     ↓

Git Push

&#x20;     ↓

GitHub

&#x20;     ↓

GitHub Actions

&#x20;     ↓

Build Application

&#x20;     ↓

Run Tests

&#x20;     ↓

Docker Build

&#x20;     ↓

Push to Amazon ECR

&#x20;     ↓

Deploy to Amazon EKS

&#x20;     ↓

Rolling Update

&#x20;     ↓

Health Check

&#x20;     ↓

Production



