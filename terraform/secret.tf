resource "kubernetes_secret" "tasky_secret" {
  metadata {
    name      = "tasky-secret"
    namespace = "default"
  }

  data = {
    DATABASE_URL                 = "cG9zdGdyZXNxbDovL25lb25kYl9vd25lcjpKYVVXOTJkc0tSdUlAZXAtam9sbHktbGFrZS1hMmhsbmVxeC5ldS1jZW50cmFsLTEuYXdzLm5lb24udGVjaC9uZW9uZGI/c3NsbW9kZT1yZXF1aXJl"
    NEXTAUTH_SECRET              = "SzZzUzcxSzNMTmRhOXprYzBvR1lzVDdOT2hTdXBBYXkvVmxjS0hQREErUT0="
    NEXTAUTH_SECRET_EXPIRES_IN   = "NTAw"
    NEXT_PUBLIC_APP_URL          = "aHR0cDovL2xvY2FsaG9zdDozMDAw"
    NEXTAUTH_URL                 = "aHR0cDovL2xvY2FsaG9zdDozMDAw"
  }

  type = "Opaque"
}
