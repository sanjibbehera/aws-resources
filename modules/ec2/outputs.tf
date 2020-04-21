# modules/ec2/outputs.tf
output "instance_ids" {
    value = "${split(",", join(",", aws_instance.web_server.*.id))}"
}