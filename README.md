# devops-local-built 🚀

A production-grade, local-first GitOps and Observability platform built entirely on **Minikube**. This project demonstrates a complete modern DevOps lifecycle: Infrastructure as Code, Containerization, GitOps deployment, and full-stack monitoring without requiring any cloud provider accounts.

## 🏗 Architecture

```text
       [ Git Repository ]
               │
               │ (Webhook / Polling)
               ▼
       [ ArgoCD Server ] ──(Scrapes Metrics)──┐
               │                              │
      (GitOps Sync / Self-Heal)               ▼
               │                      [ Prometheus ]
               ▼                              │
      [ apps Namespace ]                      ▼
    ├── Deployment (Go App)             [ Grafana ]
    ├── Service (ClusterIP)                   │
    └── ReplicaSet (x2 Pods)                  ▼
                                      [ ArgoCD Dashboard ]
🛠 Tech Stack
Cluster: Minikube (v1.37+)

Infrastructure as Code (IaC): Terraform

Package Management: Helm

Containerization: Docker (Multi-stage builds)

GitOps Engine: ArgoCD

Observability: Prometheus, Grafana, Prometheus Operator

✨ Key Features
Declarative Infrastructure: Terraform provisions namespaces (argocd, monitoring, apps) and sets resource quotas to prevent runaway workloads.

True GitOps: ArgoCD continuously monitors the k8s/ directory in this repository. Any manual cluster changes (drift) are automatically reverted (selfHeal: true), and deleted resources are pruned.

Optimized Container Builds: The Go application uses a multi-stage Docker build, reducing the final image size from ~250MB (Golang base) to just ~6MB (Alpine runtime).

Deep Pipeline Observability: Custom ServiceMonitor resources instruct Prometheus to scrape ArgoCD's internal metrics, feeding a Grafana dashboard that visualizes sync latency, health, and application drift.

🚀 Quick Start
Prerequisites
Docker Desktop (Running)

Minikube

Terraform

Helm

kubectl

1. Start the Cluster
bash
minikube start --cpus=4 --memory=6144
minikube addons enable metrics-server
minikube addons enable ingress

2. Provision the Platform (Terraform)
bash
cd terraform-platform
terraform init
terraform apply -auto-approve
cd ..

3. Bootstrap ArgoCD (Helm)
bash
./ansible-config/bootstrap.sh

4. Build & Load the App Image
bash
cd app
docker build -t myapp:v1 .
minikube image load myapp:v1
cd ..

5. Deploy the GitOps Application
bash
kubectl apply -f argocd/app.yaml

6. Install the Observability Stack
bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f monitoring-values.yaml \
  --wait

7. Connect Prometheus to ArgoCD
bash
kubectl apply -f argocd/servicemonitor.yaml
🔍 Accessing the Interfaces
ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443 (Visit https://localhost:8080)

Username: admin

Password: Run kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

Grafana UI: kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80 (Visit http://localhost:3000)

Username: admin / Password: admin

🧠 Troubleshooting Notes 
Prometheus Target shows 0/0 UP: ArgoCD's Helm chart exposes its metrics port as http-metrics (not the standard metrics). The ServiceMonitor in this repo is explicitly configured to match this non-standard port name to ensure successful scraping.

Image Pull Errors: The deployment uses imagePullPolicy: Never. The Docker image must be loaded directly into the Minikube container runtime using minikube image load myapp:v1 prior to deployment.

CRLF Warnings on Windows: Windows Git environments may throw warnings about LF/CRLF line endings. This is normal and does not affect the Kubernetes manifests.

🧹 Cleanup
To tear down the entire environment and free up local resources:

bash
terraform destroy -auto-approve -chdir=terraform-platform
minikube delete

👤 Author
Rohit A
GitHub: Rohit-A-13
