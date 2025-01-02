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
            service_name = "tasky-service"
            service_port = 80
          }
        }
      }
    }
  }
}
