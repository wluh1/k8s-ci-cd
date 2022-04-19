resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

resource "kubernetes_ingress" "argo-workflows-ingress" {
  depends_on             = [helm_release.argo-workflows]
  wait_for_load_balancer = true
  metadata {
    namespace = kubernetes_namespace.argo.metadata[0].name
    name      = "argo-workflows-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" : "/$2"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/argo(/|$)(.*)"

          backend {
            service_name = "argo-workflows-server"
            service_port = 2746
          }
        }
      }
    }
  }
}

resource "helm_release" "argo-workflows" {
  depends_on = [kubernetes_namespace.argo]
  name       = "argo-workflows"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"
  namespace  = kubernetes_namespace.argo.metadata[0].name

  set {
    name  = "server.baseHref"
    value = "/argo/"
  }

  set {
    name  = "server.extraArgs"
    value = "{--secure=false}"
  }
}
