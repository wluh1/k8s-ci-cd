resource "kubernetes_namespace" "gocd" {
  metadata {
    name = "gocd"
  }
}

resource "helm_release" "gocd" {
  name       = "gocd"
  repository = "https://gocd.github.io/helm-chart"
  chart      = "gocd"
  namespace  = kubernetes_namespace.gocd.metadata[0].name

  set {
    name  = "server.ingress.enabled"
    value = false
  }
}

resource "kubernetes_ingress" "gocd-ingress" {
  depends_on             = [helm_release.gocd]
  wait_for_load_balancer = true
  metadata {
    namespace = kubernetes_namespace.gocd.metadata[0].name
    name      = "gocd-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # "nginx.ingress.kubernetes.io/rewrite-target" : "/argo-cd/$2"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/go"

          backend {
            service_name = "gocd-server"
            service_port = 8153
          }
        }
      }
    }
  }
}


