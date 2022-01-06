package kubernetes.admission

deny[msg] {
    input.request.kind.kind == "Deployment"
    input.request.namespace == "default"

    msg := "Not allowed to create deployments in default namespace"
}