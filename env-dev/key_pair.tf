resource "tls_private_key" "ref_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ref_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.ref_tls.public_key_openssh}"
}
