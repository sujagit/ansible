variable "env" {
    default = "dev"
  
}
variable "vpc_cidr_block" {

    default = "10.0.0.0/16"
  
}

variable "subnet_1_cidr_block" {
    default = "10.0.0.0/24"
  
}

variable "availability_zone" {
    default = "us-east-1a"
  
}

variable "local_ip" {
    default = "71.62.54.165/32"
  
}
variable "jenkins_ip" {
    default = "159.89.187.32/32"
  
}
variable "ansible_ip" {
    default = "104.131.60.77/32"
  
}

variable "ssh-key" {

    default = "/Users/sujagandhiraj/.ssh/id_rsa.pub"
  
}

variable "instance_type" {
    default = "t2.micro"
  
}