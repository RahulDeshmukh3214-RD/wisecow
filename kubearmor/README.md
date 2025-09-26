Wisecow Application – DevOps Trainee Assessment
About the Project

Wisecow is a fun web app that serves random “cow-say” fortune messages.
This repository contains:

The Wisecow application (wisecow.sh)

Dockerfile for containerization

Kubernetes manifests for deployment

CI/CD pipeline for automated build & deploy

Monitoring and health-check scripts

Zero-Trust policy using KubeArmor

Problem Statement 1 – Containerisation & Kubernetes Deployment
Dockerization

Dockerfile included in repo root.

Build image locally:

docker build -t wisecow .
docker run -p 4499:4499 wisecow


Access at: http://localhost:4499

Kubernetes Deployment

Kubernetes manifests are in k8s/ directory:

deployment.yaml – Deploy Wisecow pod(s)

service.yaml – Expose app inside cluster

ingress.yaml – Expose app externally with TLS

Apply to cluster (example: k3s on AWS EC2):

kubectl apply -f k8s/
kubectl get pods
kubectl get svc
kubectl get ingress

TLS Support

Self-signed certificate example:

DOMAIN="<EC2-PUBLIC-IP-or-DOMAIN>"
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=${DOMAIN}/O=wisecow"

kubectl create secret tls wisecow-tls --cert=tls.crt --key=tls.key
kubectl apply -f k8s/ingress.yaml

 Problem Statement 1 – CI/CD Pipeline

GitHub Actions workflow file: .github/workflows/ci-cd.yml

Workflow:

On push to main, build Docker image.

Push image to GitHub Container Registry (GHCR).

SSH into EC2 → apply manifests → rollout new version.

Secrets required in GitHub repo:

SSH_HOST

SSH_USER

SSH_PRIVATE_KEY

Problem Statement 2 – Automation Scripts

Scripts are in scripts/ directory.

1. System Health Monitoring – system_health.sh

Monitors:

CPU usage

Memory usage

Disk usage

Process count

Run manually:

chmod +x scripts/system_health.sh
./scripts/system_health.sh


Schedule with cron (every 5 mins):

*/5 * * * * /home/ubuntu/wisecow/scripts/system_health.sh >> /home/ubuntu/sys_health.log

2. Application Health Checker – app_health_check.py

Checks uptime via HTTP status code.

Run:

pip3 install requests
python3 scripts/app_health_check.py http://localhost:4499


Output:

OK 200 – UP if healthy

DOWN if not responding

 Problem Statement 3 – (Optional) Zero-Trust Policy

File: kubearmor/wisecow-zero-trust.yaml

Example usage:

kubectl apply -f kubearmor/wisecow-zero-trust.yaml
karmor logs


Captures policy violations for restricted files/processes.

Repository Structure
wisecow/
├── Dockerfile
├── wisecow.sh
├── README.md
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── system_health.sh
│   └── app_health_check.py
├── kubearmor/
│   └── wisecow-zero-trust.yaml   # (optional)
└── .github/
    └── workflows/
        └── ci-cd.yml

