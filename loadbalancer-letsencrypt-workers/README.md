# DigitalOcean loadbalancer with ssl + Workers via Terraform. 

### Introduction

DigitalOcean loadbalancers provide a simple solution to loadbalance your workloads. The DigitalOcean loadbalancers have the built in function to request [let's encrypt](https://www.digitalocean.com/docs/kubernetes/how-to/connect-with-kubectl/) certificates.

In this guide, you will deploy a DigitalOcean loadbalancer with a let's encrypt certifitcate. You will also create a couple of droplets that will automaticly be tagged and placed behind the DigitalOcean loadbalancer. A Let's encrypt certificate will be automaticly provisioned and added to the loadbalancer. 

Domain record is also added based on the user entry on the terraform.tvars file.  

![Diagram](https://raw.githubusercontent.com/DO-Solutions/do-terraform/master/loadbalancer-letsencrypt-workers/img/diagram.png)

## Prerequisites

Before you begin this guide you'll need the following:

* Digitalocean account. You can create an account by navigating to the [following](https://www.digitalocean.com/) page. 
* Domain added to the digitalocean account. You will need a domain added to your DigitalOean account. This is required in order for the terraform configuration to work out of the box. You have the ability to create a fork of this repo and make it fit your needs. 
* Terraform installed on your computer. The following [article](https://learn.hashicorp.com/terraform/getting-started/install.html) provides the steps required for this installation. 
*  Doctl installed on your computer. The following [article](https://github.com/digitalocean/doctl) provides the steps required for this installation.

## Step 1 - Preparing the enviornment

Let's begin by downloading the contents of this repo to your local computer. 
This can be acheived by running the following command. 

```
git clone https://github.com/DO-Solutions/do-terraform.git
```

We will now want to change directory and inspect the terraform files. 

```
cd do-terraform/loadbalancer-letsencrypt-workers/
```

Inside of the loadbalancer-letsencrypt-workers directory you should see the following files. 

* terraform.tf
* terraform.tvars.example
* variables.tf
* nginx.sh

Make a copy of the **terraform.tvars.example** file and name it **terraform.tvars**.

```
cp terraform.tvars.example terraform.tvars
```

```
# Authentication
do_token        =   "<DO Token>"                # Digitalocean Token 

# Certificate + Loadbalancer
domain          =   "example.com"               # Domain that will be used for deployment. 
sub_domain      =   "my"                        # Subdomain that will be used for deployment.

# Worker configuration
region          =   "sfo2"                      # Region to deploy enviornment
size            =   "s-1vcpu-1gb"               # Size of droplet to deploy
tag             =   "worker"                    # Tag to add droplets to loadbalancer
name            =   "worker"                    # Name to use for droplets
image           =   "ubuntu-18-04-x64"          # Image can be replaced with snapshot ID
do-count        =   "4"                         # Number of droplets to create under loadbalancer
ssh_keys        =   "<SSH Key ID>"              # doctl compute ssh-key ls

```

## Step 2 - Deploying enviornment

To run terraform make sure you are in the directory where the terraform files live. 
In this case its **loadbalancer-letsencrypt-workers**

Run the following command.

```
terraform plan
```

If everything checks out and there are no errors you can proceed to run the apply command. 

```
terraform apply
```

If the initial apply runs into any errors, go ahead and re-run the command.

Once all of the resources are deployed you can check if everything was installed correctly by navigating to the following url. You should see the nginx welcome page and well as ssl certificate correctly securing your site. 

```
https://subdomain.domain.com
```

HTTP to HTTPS redirection will be configured so you can also check out the following as well. 

```
http://subdomain.domain.com
```

## Step 3 - Cleaning up. 

To clean up the enviornment and destroy all of the resources run the following command. 

```
terraform destroy
```

