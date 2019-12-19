output "webservers" {
    value = aws_instance.web.*.public_dns
} 

output "dbserver" {
    value = aws_instance.db.public_dns
} 