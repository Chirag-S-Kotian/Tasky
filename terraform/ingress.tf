resource "kubernetes_ingress_v1" "tasky_ingress" {
  metadata {
    name = "tasky-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "localhost"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "tasky-service"
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}