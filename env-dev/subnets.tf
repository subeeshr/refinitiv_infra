resource "aws_subnet" "refinitiv" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.azs}"
  tags {
    Name = "refinitiv_${var.env}"
    env = "${var.env}"
    terraform = "true"
    project = "${var.project}"
  }
}
