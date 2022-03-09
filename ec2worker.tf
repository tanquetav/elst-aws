
data "aws_ami" "ubuntuworker" {
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

resource "aws_instance" "worker" {
  depends_on = [
    aws_instance.master,
  ]

  count = var.worker_nodes

  subnet_id                   = aws_subnet.subnet.id
  ami                         = data.aws_ami.ubuntuworker.id
  vpc_security_group_ids      = ["${aws_security_group.forwarder.id}"]
  instance_type               = var.instance_type
  key_name                    = var.name
  user_data                   = data.cloudinit_config.cloudinit.rendered
  associate_public_ip_address = true #tfsec:ignore:aws-autoscaling-no-public-ip

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.name}"
  }
  provisioner "file" {
    source      = "files/worker.sh"
    destination = "/tmp/worker.sh"
  }

  provisioner "file" {
    content     = data.remote_file.node_token.content
    destination = "/tmp/token"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/worker.sh",
      "sudo /tmp/worker.sh ",

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


