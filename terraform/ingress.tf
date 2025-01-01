resource "kubernetes_ingress" "tasky_ingress" {
  metadata {
    name      = "tasky-ingress"
    namespace = kubernetes_namespace.tasky.metadata[0].name

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
            service {
              name = kubernetes_service.tasky_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
