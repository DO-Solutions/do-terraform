# Kubernetes cluster deployed using Terraform

### Introduction

DigitalOcean offers Kubernetes as an easily deployable service. It can be deployed and managed through the UI and API. By using Terraform though, you can express what the underlying resources should look like using code. This not only makes it easy to deploy your cluster, but also make changes as need. And example of this would be if you need to scale the number of worker nodes in a node pool or add a new worker pool altogether. Additionally, describing your infrastructure as code will also allow you to build out new environments with minor modifications as well as roll back changes if something breaks.

In this guide, you will deploy a DigitalOcean Kubernetes cluster. You'll also see how easy it is to add a new node pool by simply uncommenting the resource block that describes a new pool with a different Droplet type. 

## Prerequisites

Before you begin this guide you'll need the following:

* Digitalocean account. You can create an account by navigating to the [following](https://www.digitalocean.com/) page. 
* Terraform installed on your computer. The following [article](https://learn.hashicorp.com/terraform/getting-started/install.html) provides the steps required for this installation. 

## Step 1 - Preparing the enviornment

Let's begin by downloading the contents of this repo to your local computer. 
This can be acheived by running the following command. 

```
git clone https://github.com/DO-Solutions/do-terraform.git
```

We will now want to change directory and inspect the terraform files. 

```
cd do-terraform/k8s-cluster/
```

Inside of the **k8s-cluster** directory you should see the following files. 

* main.tf
* terraform.tvars.example
* variables.tf


Make a copy of the **terraform.tvars.example** file and name it **terraform.tvars**.

```
cp terraform.tvars.example terraform.tvars
```

Fill in values for the variables.

```
# Authentication 
do_token = ""                              # DigitalOcean API Token

# Cluster Options
cluster_name = "example-cluster"           # Cluster name
region = "sfo2"                            # Cluster data center location
```


## Step 2 - Deploying enviornment

To run terraform make sure you are in the directory where the terraform files live. 
In this case its **k8s-cluster**

Run the following command.

```
terraform plan
```

If everything checks out and there are no errors you can proceed to run the apply command. 

```
terraform apply
```

Once the terraform run has completed you should see a notice stating **Apply complete! Resources: 1 added, 0 changed, 0 destroyed.** Along with that you will notice that the terraform run has also output your kubeconfig data which can be stored in a file and placed in one of the paths of your of you `KUBECONFIG` environment variable. Once you have that configured you'll be able to run `kubectl get nodes` and see the workers in your initial node pool. 

Just so give an example of how easy it is to create an additional node pool, you can uncomment the following lines in the main.tf file by removing the leading pound sign and running `terraform apply` again.

```
resource "digitalocean_kubernetes_node_pool" "doks-cluster-np2" {
  cluster_id = "${digitalocean_kubernetes_cluster.doks_cluster.id}"

  name       = "worker-pool-2"
  size       = "c-2"
  node_count = 3
  tags       = ["np2", "backend"]
}
```

Give that a little time to complete, but once it's done you see a new node pool made up of a different class of Droplets, which can be used to deploy a different service that your application may rely on (eg. running a transcoding service on compute optimized Droplets).

## Step 3 - Cleaning up. 

To clean up the enviornment and destroy all of the resources run the following command. 

```
terraform destroy
```

#### Warning!!!

If you want to prevent the destruction of resources created by Terraform, be sure to set `prevent_destroy = true` within the resource block you want to protect.
