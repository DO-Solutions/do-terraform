# Consul cluster deployed using Terraform

### Introduction


## Prerequisites

Before you begin this guide you'll need the following:

* Digitalocean account. You can create an account by navigating to the [following](https://www.digitalocean.com/) page. 
* Terraform installed on your computer. The following [article](https://learn.hashicorp.com/terraform/getting-started/install.html) provides the steps required for this installation. 

## Step 1 - Preparing the environment

Let's begin by downloading the contents of this repo to your local computer. 
This can be achieved by running the following command. 

```
git clone https://github.com/DO-Solutions/do-terraform.git
```

We will now want to change directory and inspect the terraform files. 

```
cd do-terraform/multiserver-consul-cluster
```

Inside of the **multiserver-consul-cluster** directory you should see the following files. 

* main.tf
* interface.tf
* terraform.tfvars.example

```
cp terraform.tvars.example terraform.tvars
```

I recommend filling in the following variables as BASH environment variables.

```
DIGITALOCEAN_TOKEN

consul_gossip_key
```


## Step 2 - Deploying environment

To run terraform make sure you are in the directory where the terraform files live. 
In this case its **multiserver-consul-cluster**

Run the following command to download all plugins and modules that Terraform will need to execute this manifest.

```
terraform init
```

You can now run `terraform plan` to see what resources Terraform will be creating. You can also store this output to file if you wish and then use it later to execute from. We won't be doing that for this example, but it's something to keep in mind later when you're working on a larger deployment. If everything checks out and there are no errors you can proceed to run the apply command. 

```
terraform apply
```
## Step 3 - Cleaning up. 

To clean up the environment and destroy all of the resources run the following command. 

```
terraform destroy
```
#### Warning!!!

If you want to prevent the destruction of resources created by Terraform, be sure to set `prevent_destroy = true` within the resource block you want to protect. We've set the Droplets running the Consul Agent in server mode to **prevent_destroy = true** just in case. If you want to destroy those Droplets you need to either remove the lifecycle block from **modules/consul-server/main.tf** or just set `prevent_destroy = false`.
