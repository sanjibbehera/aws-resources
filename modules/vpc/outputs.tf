#-----modules/vpc/outputs.tf----

output "subnet_id" {
  value = "${aws_subnet.sanjib_public_subnet.*.id}"
}

output "security_group_id" {
  value = "${aws_security_group.sanjib_public_sg.id}"
}