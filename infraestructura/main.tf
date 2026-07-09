
resource "aws_vpc" "cafe_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cafe-vpc"
  }
}


resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.cafe_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.cafe_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true
}



resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.cafe_vpc.id
}


resource "aws_route_table" "public" {

  vpc_id = aws_vpc.cafe_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}




resource "aws_route_table_association" "a" {

  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {

  subnet_id = aws_subnet.public_b.id

  route_table_id = aws_route_table.public.id
}



resource "aws_security_group" "web_sg" {

  name = "web-sg"

  vpc_id = aws_vpc.cafe_vpc.id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
