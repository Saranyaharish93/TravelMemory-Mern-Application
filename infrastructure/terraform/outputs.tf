output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of the web server"
  value       = aws_instance.web_server.private_ip
}

output "database_server_private_ip" {
  description = "Private IP of the MongoDB server"
  value       = aws_instance.database_server.private_ip
}

output "web_server_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web_server.public_dns
}

output "ssh_command" {
  description = "Command to connect to the public web server"
  value       = "ssh -i ~/.ssh/travelmemory-key.pem ubuntu@${aws_instance.web_server.public_ip}"
}