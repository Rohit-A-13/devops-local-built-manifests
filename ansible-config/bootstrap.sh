#!/usr/bin/env bash
#
# Bootstrap script for devops-local-built
# Equivalent to ansible-config/bootstrap.yml
# Installs ArgoCD via Helm with metrics enabled.
#
set -euo pipefail

echo "==> Adding Helm repositories..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "==> Installing ArgoCD..."
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --version 7.7.11 \
  --set server.service.type=NodePort \
  --set server.metrics.enabled=true \
  --set controller.metrics.enabled=true \
  --set repoServer.metrics.enabled=true \
  --wait \
  --timeout 10m

echo ""
echo "==> ArgoCD installed. Pods:"
kubectl get pods -n argocd

echo ""
echo "==> ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo
