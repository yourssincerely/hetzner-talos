resource "hcloud_firewall_attachment" "talos_cp" {
    firewall_id     = hcloud_firewall.talos_cp.id
    label_selectors = [
        "role=control-plane"
    ]
    depends_on = [
        talos_cluster_kubeconfig.kubeconfig
    ]
}
resource "hcloud_firewall_attachment" "talos_worker" {
    firewall_id     = hcloud_firewall.talos_worker.id
    label_selectors = [
        "role=worker"
    ]
    depends_on = [
        talos_cluster_kubeconfig.kubeconfig
    ]
}
resource "hcloud_firewall_attachment" "kubernetes_cp" {
    firewall_id     = hcloud_firewall.kubernetes_cp.id
    label_selectors = [
        "role=control-plane"
    ]
    depends_on = [
        talos_cluster_kubeconfig.kubeconfig
    ]
}
resource "hcloud_firewall_attachment" "kubernetes_worker" {
    firewall_id     = hcloud_firewall.kubernetes_worker.id
    label_selectors = [
        "role=worker"
    ]
    depends_on = [
        talos_cluster_kubeconfig.kubeconfig
    ]
}
