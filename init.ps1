helm repo add argo https://argoproj.github.io/argo-helm
kubectl create namespace argocd
helm upgrade --install --namespace  argocd  argocd argo/argo-cd -f .\infra\values\argocd.yaml
kubectl apply -f root.yaml

kubectl apply -f .\infra\auth-acmedns.yaml
kubectl apply -f .\infra\clusterissuer.yaml


kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | TODO: Get from base 64

kubectl port-forward service/argocd-server -n argocd 8080:443
