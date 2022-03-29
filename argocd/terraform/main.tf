resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_ingress" "argocd-ingress" {
  depends_on             = [helm_release.argocd]
  wait_for_load_balancer = true
  metadata {
    namespace = kubernetes_namespace.argocd.metadata[0].name
    name      = "argocd-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "argocd-server"
            service_port = 80
          }
        }
      }
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }
}
