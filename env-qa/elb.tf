resource "aws_elb" "load_balancer" {
  name               = "refinitiv-aem-elb"
  internal    = "${var.elb_internal}"
  subnets = ["${aws_subnet.refinitiv.id}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]

  access_logs {
    bucket        = "${var.s3_bucket_name}"
    enabled = true
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances = ["${aws_instance.author.id}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "refinitiv-aem-elb"
  }
}
