
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "master" {

  subnet_id                   = aws_subnet.subnet.id
  ami                         = data.aws_ami.ubuntu.id
  vpc_security_group_ids      = ["${aws_security_group.forwarder.id}"]
  instance_type               = "t3a.medium"
  key_name                    = var.name
  user_data                   = data.cloudinit_config.cloudinit.rendered
  associate_public_ip_address = true #tfsec:ignore:aws-autoscaling-no-public-ip

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = {
    Name = "${var.name}"
  }

  provisioner "file" {
    source      = "files/master.sh"
    destination = "/tmp/master.sh"
  }

  provisioner "file" {
    content     = tls_self_signed_cert.example.cert_pem
    destination = "/tmp/kibana-server.crt"
  }

  provisioner "file" {
    content     = tls_private_key.example.private_key_pem
    destination = "/tmp/kibana-server.key"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/master.sh",
      "sudo /tmp/master.sh",

    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    agent       = true
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

}

data "remote_file" "node_token" {
  depends_on = [
    aws_instance.master,
  ]

  conn {
    host        = coalesce(aws_instance.master.public_ip, aws_instance.master.private_ip)
    agent       = true
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  path = "/home/ubuntu/node_token"
}

data "remote_file" "elastic_password" {
  depends_on = [
    aws_instance.master,
  ]

  conn {
    host        = coalesce(aws_instance.master.public_ip, aws_instance.master.private_ip)
    agent       = true
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }

  path = "/home/ubuntu/elastic_password"
}


