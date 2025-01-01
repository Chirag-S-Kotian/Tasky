resource "kubernetes_namespace" "tasky" {
  metadata {
    name = "default"
  }
}
