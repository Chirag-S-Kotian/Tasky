resource "kubernetes_deployment" "tasky_deployment" {
  metadata {
    name      = "tasky-deployment"
    namespace = kubernetes_namespace.tasky.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "tasky"
      }
    }

    template {
      metadata {
        labels = {
          app = "tasky"
        }
      }

      spec {
        container {
          name  = "tasky"
          image = "chirag117/tasky:latest"

          ports {
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.tasky_config.metadata[0].name
            }
            secret_ref {
              name = kubernetes_secret.tasky_secret.metadata[0].name
            }
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}
