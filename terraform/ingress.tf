resource "kubernetes_ingress" "tasky_ingress" {
  metadata {
    name      = "tasky-ingress"
    namespace = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "localhost"

      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.tasky_service.metadata[0].name
            service_port = kubernetes_service.tasky_service.spec[0].port[0].port
          }
        }
      }
    }
  }
}
