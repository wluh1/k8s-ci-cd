resource "kubernetes_namespace" "chaos-testing" {
  metadata {
    name = "chaos-testing"
  }
}

resource "helm_release" "chaosmesh" {
  name       = "chaos-mesh"
  repository = "https://charts.chaos-mesh.org"
  chart      = "chaos-mesh"
  namespace  = kubernetes_namespace.chaos-testing.metadata[0].name
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
