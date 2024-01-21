talosctl apply-config --insecure -n 192.168.13.10 --file ./cluster/controlplane.yaml

talosctl kubeconfig --talosconfig ./cluster/talosconfig --endpoints 192.168.13.10 --nodes 192.168.13.10

talosctl --talosconfig ./cluster/talosconfig --endpoints 192.168.13.10 --nodes 192.168.13.10 get members
talosctl --talosconfig ./cluster/talosconfig --endpoints 192.168.13.10 --nodes 192.168.13.10 dmesg 

talosctl --talosconfig ./cluster/talosconfig --endpoints 192.168.13.10 --nodes 192.168.13.10 bootstrap

talosctl --talosconfig ./cluster/talosconfig --endpoints 192.168.13.10 --nodes 192.168.13.10 health


kubectl create ns certmanager
kubectl apply -f ./infra/auth-acmedns.yaml

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm upgrade --install --namespace argocd argocd argo/argo-cd -f ./infra/values/argocd.yaml
kubectl apply -f root.yaml

kubectl get pods -A
kubectl get application -A

$base64Pwd = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Pwd))
