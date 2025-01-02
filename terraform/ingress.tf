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
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "tasky-service"
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
