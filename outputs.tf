output "ami_id" {
  value = data.aws_ami.latest_ubuntu_server_image.id
}

output "ec2_instance_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "elastic_ip" {
  value = aws_eip.eip.public_ip
}

output "domain" {
  value = var.domain_name
}
