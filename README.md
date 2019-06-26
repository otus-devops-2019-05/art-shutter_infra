# art-shutiter_infra

Repository with home tasks for OTUS/express42 DevOps course.

## 18.06 GCP BastionHost/VPN

###IP settings

bastion_IP = 35.207.160.111 

someinternalhost_IP = 10.156.0.3

###connecting via ssh tunnel

Pass <someinternalhost> arguments to the initial ssh command, like this:

```bash
foo@bar:~$ ssh -A -t user@<bastion> ssh -A -t <someinternalhost>
```

To make it quick, you can use bash aliases. Add this to your `$HOME/.bashrc`

```bash
foo@bar:~$ alias bastion_tunnel='ssh -A -t user@<bastion> ssh -A -t <someinternalhost>'
```

###pritunl + Let's Encrypt

To get rid of self-signed cert warnings, you can obtain an SSL cert from Let's Encrypt.
You will need a domain name. Use a custom one, or use one from [sslip.io](https://sslip.io/).
Enter you domain name into 'Lets Encrypt Domain' field in pritunl's settings.

Next time you access the pritunl webpanel, use the domain name you've just configured.

## 20.06 GCP deploy a test app

###IP settings

testapp_IP = 35.198.167.169

testapp_port = 9292


