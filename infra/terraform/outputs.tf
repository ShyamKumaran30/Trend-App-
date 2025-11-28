output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

# Output the EKS cluster endpoint
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
  description = "EKS cluster API endpoint"
}

# Output the EKS cluster name
output "eks_cluster_name" {
  value = module.eks.cluster_id
  description = "EKS cluster name"
}

# Output the kubeconfig certificate authority data
output "eks_cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority_data
  description = "Certificate authority for the EKS cluster"
}

# Output the Node Group names
output "eks_node_group_names" {
  value = keys(module.eks.eks_managed_node_groups)
  description = "Names of the EKS managed node groups"
}
