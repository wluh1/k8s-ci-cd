resource "kubernetes_namespace" "argo-workflows" {
  metadata {
    name = "argo-workflows"
  }
}

resource "kubernetes_ingress" "argo-workflows-ingress" {
  depends_on             = [helm_release.argo-workflows]
  wait_for_load_balancer = true
  metadata {
    namespace = kubernetes_namespace.argo-workflows.metadata[0].name
    name      = "argo-workflows-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "ingress.kubernetes.io/rewrite-target" : "/$2"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/argo-workflow(/|$)(.*)"

          backend {
            service_name = "argo-workflows-server"
            service_port = 2743
          }
        }
      }
    }
  }
}

resource "helm_release" "argo-workflows" {
  name       = "argo-workflows"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"
  namespace  = "argo-workflows"

  set {
    name  = "server.baseHref"
    value = "/argo-workflow/"
  }
}
