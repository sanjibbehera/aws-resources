# modules/vpc/outputs.tf
output "vpc_id" {
    value = "${aws_vpc.sanjib_vpc.id}"
}
output "public_subnet_id" {
  value = "${aws_subnet.sanjib_public_subnet.*.id}"
}