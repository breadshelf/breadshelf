sudo yum update -y

# Install CloudWatch Agent
sudo yum install amazon-cloudwatch-agent -y

sudo yum install -y docker

sudo service docker start

sudo usermod -aG docker ec2-user