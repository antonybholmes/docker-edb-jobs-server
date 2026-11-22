# docker-edb-db-server

## Setup

# Backups

Perform a backup using the following:

- `docker exec pg-db pg_dump -U edb --inserts edb > backup.sql`

# EC2 endpoint

Need to create EC2 Instance endpoint to get access to machines in private subnet

https://us-east-1.console.aws.amazon.com/vpcconsole/home?region=us-east-1#Endpoints:

## Mounting volume

1. lsblk
2. sudo mkfs.xfs /dev/nvme1n1
3. sudo mkdir -p /data
4. sudo mount -t xfs /dev/nvme1n1 /data

### Load in fstab

UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID=$UUID /data xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab

### Make folders for storing data

Run to ensure image can write to external store:

sudo chown -R ec2-user:ec2-user /data
sudo chmod 755 /data

mkdir -p /data/postgres
mkdir -p /data/pgadmin
sudo chown 999:999 /data/postgres
sudo chown -R 5050:5050 /data/pgadmin

## Docker

### Install

sudo dnf update -y

sudo dnf install docker -y

sudo systemctl enable docker
sudo systemctl start docker

### Run without sudo

sudo usermod -aG docker ec2-user

newgrp docker

docker ps

# Create Docker CLI plugins directory

sudo mkdir -p /usr/local/lib/docker/cli-plugins

# Download Docker Compose (automatically detects CPU architecture)

sudo curl -SL \
 "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
 -o /usr/local/lib/docker/cli-plugins/docker-compose

# Make executable

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Install postgres stuff

sudo dnf update -y && sudo dnf install git -y

ssh-keygen -t ed25519 -C "antony@antonyholmes.dev"
cat ~/.ssh/id_ed25519.pub
git clone git@github.com:antonybholmes/docker-edb-db-server.git

# connecting pgadmin

Look for docker ip address:
ip route | grep docker0 -> 172.17.0.1

### pgadmin

Host 172.17.0.1
Port 5433
Maintenance database postgres
Username postgres
Password Your PostgreSQL password
# docker-edb-job-server
