resource "kubernetes_namespace" "drone" {
  metadata {
    name = "drone"
  }
}

resource "kubectl_manifest" "drone-secret" {
  depends_on = [kubernetes_namespace.drone]
  yaml_body  = file("./drone-secret.yaml")
}

resource "helm_release" "droneio" {
  depends_on       = [kubectl_manifest.drone-secret]
  name             = "drone"
  repository       = "https://charts.drone.io"
  chart            = "drone"
  namespace        = kubernetes_namespace.drone.metadata[0].name
  create_namespace = true
  values = [
    "${file("./drone-values.yaml")}"
  ]
}

resource "kubernetes_ingress" "drone-ingress" {
  depends_on             = [helm_release.droneio]
  wait_for_load_balancer = true
  metadata {
    namespace = kubernetes_namespace.drone.metadata[0].name
    name      = "drone-ingress"
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
            service_name = "drone"
            service_port = 80
          }
        }
      }
    }
  }
}

resource "helm_release" "drone-runner" {
  depends_on = [helm_release.droneio]
  name       = "drone-runner-kube"
  repository = "https://charts.drone.io"
  chart      = "drone-runner-kube"
  namespace  = kubernetes_namespace.drone.metadata[0].name
  values = [
    "${file("./drone-runner-kube-values.yaml")}"
  ]
}
