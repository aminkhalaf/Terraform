#before we create instance, here we test filter with output resource

/* output "aws_ami_id" {
  value = data.aws_ami.lastest-amazon-linux-image.id
} */

#this output resource gives us the public IP for the ec2 which created
output "ec2_public_ip" {
  value = module.myapp-server.instance.public_ip
}