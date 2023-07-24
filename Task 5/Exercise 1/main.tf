provider "aws" {
  access_key = "my-access"
  secret_key = "my-secret"
  region = "us-east-1"
}

resource "aws_instance" "Udacity-T2" {
    ami = "ami-04823729c75214919"
    instance_type = "t2.micro"
    count = 4
    tags = {
        "Name" = "Udacity T2"
    }
}

resource "aws_instance" "Udacity-M4" {
    ami = "ami-04823729c75214919"
    instance_type = "m4.large"
    count = 2
    tags = {
        "Name" = "Udacity M4"
    }
}