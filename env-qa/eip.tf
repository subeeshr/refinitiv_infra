resource "aws_eip" "refinitiv_eip" {
  instance = "${aws_instance.author.id}"
  vpc      = true
}
