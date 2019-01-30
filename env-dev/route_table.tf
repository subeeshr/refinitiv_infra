# Main route table -> private (main - ie, the default)
resource "aws_route_table" "ref_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "smi_${var.env}_main"
    env = "${var.env}"
    terraform = "true"
    project = "${var.project}"
  }
}

resource "aws_main_route_table_association" "ref_main_rt" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.ref_route_table.id}"
}

# Egress route table -> IGW (only for NAT Gateways)
resource "aws_route_table" "egress" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "smi_${var.env}_egress"
    env = "${var.env}"
    terraform = "true"
    project = "${var.project}"
  }
}

resource "aws_route" "egress" {
  route_table_id = "${aws_route_table.egress.id}"
  depends_on = ["aws_route_table.egress"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "egress" {
  count = 1
  subnet_id = "${aws_subnet.refinitiv.id}"
  route_table_id = "${aws_route_table.egress.id}"
}
