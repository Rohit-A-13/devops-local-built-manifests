# devops-local-built

A local-first DevOps / GitOps platform: Terraform, Helm, Docker, ArgoCD, Prometheus, Grafana — all on Minikube.

## Components

- **Terraform** — namespaces + resource quotas (IaC)
- **Helm** — bootstrap ArgoCD + monitoring
- **Docker** — multi-stage Go app (~6MB)
- **ArgoCD** — GitOps sync with self-heal
- **Prometheus + Grafana** — ArgoCD metrics + dashboards

## Quick Start

```bash
minikube start --cpus=4 --memory=6144
cd terraform-platform && terraform init && terraform apply -auto-approve
../ansible-config/bootstrap.sh
cd ../app && docker build -t myapp:v1 . && minikube image load myapp:v1
kubectl apply -f ../argocd/app.yaml
```
