output "public_ip" {
  value       = aws_instance.master.public_ip
  description = "AMI"
}

output "public_ip_worker" {
  value       = aws_instance.worker[*].public_ip
  description = "AMI"
}

output "elastic_password" {
  value       = data.remote_file.elastic_password.content
  description = "Elastic Password"
  sensitive   = true
}
