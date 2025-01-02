resource "kubernetes_deployment" "tasky_deployment" {
  metadata {
    name      = "tasky-deployment"
    namespace = "default"
    labels = {
      app = "tasky"
    }
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

          port {
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = "tasky-config"
            }
          }

          env_from {
            secret_ref {
              name = "tasky-secret"
            }
          }

          resources {
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }

            requests = {
              memory = "256Mi"
              cpu    = "250m"
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
