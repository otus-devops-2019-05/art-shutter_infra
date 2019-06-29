# art-shutiter_infra

Repository with home tasks for OTUS/express42 DevOps course.

## 3. 18.06 GCP BastionHost/VPN

### IP settings

bastion_IP = 35.207.160.111 

someinternalhost_IP = 10.156.0.3

### connecting via ssh tunnel

Pass <someinternalhost> arguments to the initial ssh command, like this:

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
--metadata startup-script='#! /bin/bash
log=initialization_script.log
apt update && apt install -y ruby-full ruby-bundler build-essential
ruby -v 2>&1  | tee -a $log
bundler -v 2>&1 | tee -a $log
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update && apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod 2>&1 | tee -a $log
systemctl status mongod 2>&1 | tee -a $log
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d 2>&1 | tee -a $log
ps aux | grep puma | tee -a $log'
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
