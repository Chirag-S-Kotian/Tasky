




# Project Goku - Enterprise-Grade Kubernetes Deployment structure


## Overview

Project Goku is a production-ready Kubernetes deployment solution implementing GitOps principles and Infrastructure as Code (IaC). This project demonstrates a complete CI/CD pipeline using modern DevOps practices including:


- Infrastructure as Code using Terraform

- Container orchestration with Kubernetes (EKS)

- GitOps workflow with GitHub Actions

- Helm-based application deployment

- Automated container builds and deployments

- Monitoring and observability setup and deployment



### Architecture Overview


```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   GitHub Actions │────>│   AWS EKS        │────>│   Application    │
│   CI/CD Pipeline │     │   Infrastructure │     │   Deployment     │
└──────────────────┘     └──────────────────┘     └──────────────────┘
        │                        │                         │
        │                        │                         │
        v                        v                         v
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Docker Hub     │     │   Terraform      │     │   Helm Charts    │
│   Registry       │     │   State          │     │   Management     │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

### Technical Stack

- **Infrastructure**: AWS EKS, VPC, Subnets
- **IaC**: Terraform
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Package Management**: Helm
- **CI/CD**: GitHub Actions
- **Registry**: Docker Hub
- **Monitoring**: Prometheus Ready


## Prerequisites Installation

```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS CLI
aws configure

# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Region: ap-south-1
# Output format: json


# Install Terraform

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Install Helm

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Project Setup

1. Create Project Structure

```bash
mkdir -p ~/Desktop/THREE/goku/{terraform,helm/gok-shart,.github/workflows}
cd ~/Desktop/THREE/goku
```

2. Initialize Terraform

```bash
cd terraform
terraform init
```

3. Deploy Infrastructure

```bash
# Review the plan
terraform plan

# Apply the infrastructure
terraform apply -auto-approve
```

4. Connect to EKS

```bash
aws eks update-kubeconfig --name gok-cluster --region ap-south-1
kubectl get nodes # Verify connection
```

5. Deploy Application
```bash
# Create Docker image
docker build -t chirag117/gok:v1 .
docker push chirag117/gok:v1

# Deploy using Helm
helm install gok ./helm/gok-shart
```

## GitHub Actions Setup

1. Add Repository Secrets
- Go to Settings > Secrets and variables > Actions
- Add these secrets:
  - DOCKERHUB_USERNAME
  - DOCKERHUB_TOKEN
  - GIT_TOKEN

2. Enable GitHub Actions
- Go to Actions tab
- Enable workflows
- Push code to trigger the pipeline

## Verification Steps

1. Check Infrastructure
```bash
# Verify EKS cluster
kubectl get nodes
kubectl get pods -A

# Check networking
kubectl get svc
kubectl get ingress
```

2. Test Application
```bash
# Get NodePort service URL
kubectl get svc gok -o wide

# Get Ingress URL
kubectl get ingress gok
```

## Cleanup

1. Remove Application
```bash
helm uninstall gok
```

2. Destroy Infrastructure
```bash
cd terraform
terraform destroy -auto-approve
```

## Troubleshooting Guide

1. Pod Issues
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

2. EKS Issues
```bash
aws eks describe-cluster --name gok-cluster
kubectl get events --sort-by='.lastTimestamp'
```

3. Common Problems and Solutions
- Pods not starting: Check IAM roles and security groups
- Network issues: Verify VPC and subnet configurations
- Image pull errors: Check DockerHub credentials
- Ingress not working: Verify Nginx Ingress Controller installation

## Advanced Operations

### Monitoring and Logging
1. Prometheus Integration
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

2. Grafana Dashboard Setup
```bash
kubectl port-forward svc/prometheus-grafana 3000:80
# Default credentials:
# Username: admin
# Password: prom-operator
```

### Scaling and Performance
1. Horizontal Pod Autoscaling
```bash
kubectl autoscale deployment gok --cpu-percent=80 --min=3 --max=10
```

2. Cluster Autoscaling
```bash
# Enable cluster autoscaler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

### Backup and Disaster Recovery
1. Velero Setup
```bash
# Install Velero
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.0 \
    --bucket $BUCKET_NAME \
    --backup-location-config region=ap-south-1 \
    --snapshot-location-config region=ap-south-1
```

2. Regular Backups
```bash
# Create backup
velero backup create gok-backup --include-namespaces default

# Restore from backup
velero restore create --from-backup gok-backup
```

## Production Best Practices
1. **Security Measures**
   - Enable Network Policies
   - Implement Pod Security Policies
   - Regular security audits
   - AWS WAF integration

2. **High Availability**
   - Multi-AZ deployment
   - Pod anti-affinity rules
   - Liveness and readiness probes
   - PodDisruptionBudgets

3. **Monitoring and Alerting**
   - Prometheus metrics
   - Grafana dashboards
   - AlertManager configuration
   - Slack/PagerDuty integration


4. **Cost Optimization**
   - Resource requests/limits
   - Spot instances utilization
   - Regular cost analysis
   - Cleanup of unused resources

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| EKS Node Group Failure | Check IAM roles and instance profile |
| Image Pull Errors | Verify registry credentials and network connectivity |
| Helm Chart Issues | Validate values.yaml and template syntax |
| Pipeline Failures | Check GitHub Actions logs and secrets |

## Contact and Support
- **Project Maintainer**: Chirag S Kotian
- **Issue Tracking**: [GitHub Issues](https://github.com/yourusername/goku/issues)