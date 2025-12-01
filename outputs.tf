output "strapi_url" {
  description = "Strapi API endpoint URL"
  value       = "http://${aws_eip.strapi_eip.public_ip}:1337"
}

output "strapi_admin_url" {
  description = "Strapi Admin Panel URL"
  value       = "http://${aws_eip.strapi_eip.public_ip}:1337/admin"
}

output "instance_public_ip" {
  description = "Public IP of the Strapi instance"
  value       = aws_eip.strapi_eip.public_ip
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.strapi_eip.public_ip}"
}
