# modules/vpc/outputs.tf
output "vpc_id" {
    value = "${aws_vpc.sanjib_vpc.id}"
}
output "public_subnet_id" {
  value = "${aws_subnet.sanjib_public_subnet.*.id}"
}
output "private_subnet_id" {
  value = "${aws_subnet.sanjib_private_subnet.*.id}"
}

output "public_subnets" {
  value = "${tolist(aws_subnet.sanjib_public_subnet.*.id)}"
}

output "availability_zones" {
  value = "${join(", ", aws_subnet.sanjib_public_subnet.*.availability_zone_id)}"
}

