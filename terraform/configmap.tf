resource "kubernetes_config_map" "tasky_config" {
  metadata {
    name      = "tasky-config"
    namespace = "default"
  }

  data = {
    NEXT_PUBLIC_APP_URL          = "http://localhost:3000"
    NEXTAUTH_URL                 = "http://localhost:3000"
    NEXTAUTH_SECRET_EXPIRES_IN   = "3600"
  }
}
