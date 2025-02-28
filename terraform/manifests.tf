resource "kubernetes_deployment" "gok" {
  metadata {
    name = "gok"
    labels = {
      app = "gok"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "gok"
      }
    }
    template {
      metadata {
        labels = {
          app = "gok"
        }
      }
      spec {
        container {
          name  = "gok"
          image = "chirag117/gok:v1"
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
          port {
            container_port = 3000
          }
        }
      }
    }
  }
  depends_on = [aws_eks_node_group.gok]
}

resource "kubernetes_service" "gok" {
  metadata {
    name = "gok"
    labels = {
      app = "gok"
    }
  }
  spec {
    selector = {
      app = "gok"
    }
    port {
      port        = 80
      target_port = "3000"
      protocol    = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "gok" {
  metadata {
    name = "gok"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "gok.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "gok"
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