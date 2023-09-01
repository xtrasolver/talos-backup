talosctl patch --mode=no-reboot machineconfig -n 192.168.13.10 --patch @openebs-patch.yaml
talosctl -e 192.168.13.10 -n 192.168.13.10 upgrade --image=ghcr.io/siderolabs/installer:v1.5.1 --preserve
talosctl -e 192.168.13.10 -n 192.168.13.10 get extensions
talosctl -e 192.168.13.10 -n 192.168.13.10 get services
talosctl -n 192.168.13.10 service kubelet restart


helm repo add argo https://argoproj.github.io/argo-helm
kubectl create namespace argocd
helm upgrade --install --namespace  argocd  argocd argo/argo-cd -f .\infra\values\argocd.yaml
kubectl apply -f root.yaml

#kubectl port-forward service/argocd-server -n argocd 8080:443


kubectl apply -f .\infra\auth-acmedns.yaml
kubectl apply -f .\infra\clusterissuer.yaml

$base64Pwd = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Pwd))

$base64Token = kubectl -n minio-operator get secret console-sa-secret -o jsonpath="{.data.token}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Token))
