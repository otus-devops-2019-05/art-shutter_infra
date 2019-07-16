# art-shutiter_infra

Repository with home tasks for OTUS/express42 DevOps course.

## 3. 18.06 GCP BastionHost/VPN

### IP settings

bastion_IP = 35.207.160.111 

someinternalhost_IP = 10.156.0.3

### connecting via ssh tunnel

Pass `<someinternalhost>` arguments to the initial ssh command, like this:

```bash
foo@bar:~$ ssh -A -t user@<bastion> ssh -A -t <someinternalhost>
```

To make it quick, you can use bash aliases. Add this to your `$HOME/.bashrc`

```bash
foo@bar:~$ alias bastion_tunnel='ssh -A -t user@<bastion> ssh -A -t <someinternalhost>'
```

### pritunl + Let's Encrypt

To get rid of self-signed cert warnings, you can obtain an SSL cert from Let's Encrypt.
You will need a domain name. Use a custom one, or use one from [sslip.io](https://sslip.io/).
Enter you domain name into 'Lets Encrypt Domain' field in pritunl's settings.

Next time you access the pritunl webpanel, use the domain name you've just configured.

## 4. 20.06 GCP deploy test app

### IP settings

testapp_IP = 35.195.168.81

testapp_port = 9292

### Startup script

To run a startup script at the creation of the instance, run this command:

```shell
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata startup-script="#! /bin/bash
log=initialization_script.log
apt update && apt install -y ruby-full ruby-bundler build-essential
ruby -v 2>&1  | tee -a $log
bundler -v 2>&1 | tee -a $log
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

# Add mongodb repo

cat <<EOF > /etc/apt/sources.list.d/mongodb.list
deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse
EOF

apt update && apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod 2>&1 | tee -a $log
systemctl status mongod 2>&1 | tee -a $log
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d 2>&1 | tee -a $log
ps aux | grep puma | tee -a $log"
```

### Create firewall rule using gcloud

Use this command:

```shell
gcloud compute firewall-rules create default-puma-server \
--allow tcp:9292 \
--target-tags puma-server
```

## 5. 25.06 Packer

### Install packer

To install packer, follow instructions [here](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries).

### Packer's JSON file sections

There are 'builders' and 'provisioners'. Use 'builders' to specify vm instance options and 'provisioners' to specify what has to be baked into the image. Example of 'provisioners':

```
"provisioners": [
        {
            "type": "shell",
            "script": "scripts/install_ruby.sh",
            "execute_command": "sudo {{.Path}}"
        }
]
```

### Variables in Packer

You can specify variables
- inside the main .json
- in separate .json with variables (don't add it as a new section, plain object); in this case specify `-var-file=file.json`
- as cli parameter, for instance `-var 'image_family=ubuntu'`

### Running required VM with gcloud

Possible command would be:

```shell
gcloud compute instances create reddit-app \
--image-family reddit-full \
--machine-type=g1-small \
--restart-on-failure
```

## 6. 27.06 Terraform-1

### Storing and setting variables

Set variables and their defaults in any `<filename>.tf`

```
variable "zone" {
  description = "Project zone"
  default     = "us-central1-a"
}
```

Set var values in `<filename>.tfvars` file like this:

```
project = "project_ID"
region = "us-central1-a"
public_key_path = "path_to_ssh_pub_file"
private_key_path = "path_to_ssh_private_key"
disk_image = "image_name"
```

### Adding several ssh-keys to metadata

In order to add more than one ssh-key, use \n to separate lines

```
metadata {
ssh-keys = "appuser:${file(var.public_key_path)} \nappuser1:${file(var.public_key_path)}
}
```

As well as that, you could use the 'here-document' syntax. Mind the absence of extra spaces and formatting.

```
  metadata {
    ssh-keys = <<EOF
appuser:${file(var.public_key_path)}
appuser1:${file(var.public_key_path)}
EOF
  }
```

You can add these keys project-wide, just specify the correct resource

```
resource "google_compute_project_metadata" "ssh-keys" {}
```

### Using web-interface

Be careful! Any changes you make in the web-interface don't get updated in the .tfstate file, thus any changes you make outside of Terrafom get overwritten with the next `apply` command.

## 7. 02.07 Terraform-2

To keep `tfstate` file updated and synced, you could use buckets and a seperate backend. 
For each envirnment, define parameters in `backend.tf`.

In the root of the repo, conigure buckets themselves.

```ruby
module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  
  name = ["storage-bucket-changemename", "storage-bucket-changemename2"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
```

Don't forget to re-initialize terraform to create buckets.

## 8. 11.07 Ansible-1

