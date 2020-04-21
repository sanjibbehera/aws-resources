# modules/ec2/outputs.tf
output "instance_ids" {
    value = "${split(",", join(",", aws_instance.web_server.*.id))}"
}

output "public_security_group_id" {
    value = "${aws_security_group.sanjib_public_sg.id}"
}