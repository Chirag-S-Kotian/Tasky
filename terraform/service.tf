resource "kubernetes_service" "tasky_service" {
  metadata {
    name      = "tasky-service"
    namespace = kubernetes_namespace.tasky.metadata[0].name
  }

  spec {
    selector = {
      app = "tasky"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }

    type = "NodePort"
  }
}
