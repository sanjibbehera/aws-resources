# modules/ec2/outputs.tf
output "instance_ids" {
    value = "${split(",", join(",", aws_instance.web_server.*.id))}"
}

output "private_security_group_id" {
    value = "${aws_security_group.sanjib_private_sg.id}"
}

output "base_ec2_instance" {
    value = "${aws_instance.base_ami_server.*.id}"
}