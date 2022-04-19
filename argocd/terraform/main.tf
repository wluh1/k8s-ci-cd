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
      "nginx.ingress.kubernetes.io/rewrite-target" : "/argo-cd/$2"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/argo-cd(/|$)(.*)"

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
    value = "{--insecure,--basehref,/argo-cd,--rootpath,/argo-cd}"
  }
}
# , 
