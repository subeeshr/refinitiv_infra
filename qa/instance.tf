resource "aws_instance" "author" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.refinitiv.id}"
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  tags = {
    Name = "author"
  }
}
