

module "chaosmesh" {
  source  = "3191110276/chaosmesh/kubernetes"
  version = "0.1.5"
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "nginx-ingress" {
  depends_on = [kubernetes_namespace.nginx]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.nginx.metadata[0].name

  set {
    name  = "controller.service.loadBalancerIP"
    value = "35.241.195.23"
  }
}
