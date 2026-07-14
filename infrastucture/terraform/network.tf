resource "aws_subnet" "public_subnet_1" {

  vpc_id = aws_vpc.bank_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true


  tags = {

    Name = "${var.project_name}-public-1"

  }

}


resource "aws_subnet" "public_subnet_2" {

  vpc_id = aws_vpc.bank_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true


  tags = {

    Name = "${var.project_name}-public-2"

  }

}


resource "aws_route_table" "public" {

  vpc_id = aws_vpc.bank_vpc.id


  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }


  tags = {

    Name = "${var.project_name}-public-route"

  }

}


resource "aws_route_table_association" "subnet1" {

  subnet_id = aws_subnet.public_subnet_1.id

  route_table_id = aws_route_table.public.id

}


resource "aws_route_table_association" "subnet2" {

  subnet_id = aws_subnet.public_subnet_2.id

  route_table_id = aws_route_table.public.id

}
