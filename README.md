# Ansible Demo App
This is a small app written in Flask (1.11.x/Python 3.x) using MySQL 8 as a data store. Front end uses HTML+Jinja2+Bootstrap4

## Prerequisites
	* Terraform
	* Ansible
	* Python 3.x
	* AWS CLI
	* EC2 instances with RHEL8 or compatible OS (this won’t work on Debian or Amazon Linux Based Oses)

## Deployment of the demo
	* First clone this repo to your local environment
	* Edit the **hosts** file inside the *playbooks* folder
	![](Ansible%20Demo%20App/45B85602-9CB2-452E-9F5E-A6450D2962CB.png)
	* 	There add the web servers (could be one or many) and the db-server you will use to deploy (only one DBserver should be created, you could create and provision another one, but they won’t work as a cluster)
	* Then, still inside the *playbooks* folder, go to the *global_vars* folder and then the **all.yml** file and change:
		* The location of the ansible_ssh_private_key, to the location of your private key, that will be used to connect to the servers in the inventory
		* Change the SQLALCHEMY_DATABASE_URI variable in the part corresponding to the DBServer
	
![](Ansible%20Demo%20App/A27FF2A9-0924-43E7-890A-DF60A0C05A7F.png)

		* If you would like to change the mysqlpassword you could do it here, and then in the **dbserver.yml** file in the same folder
		
		![](Ansible%20Demo%20App/DC3C9020-1898-4E81-87E5-F10735F2EDD0.png)
Yes it’s insecure, but for the effects of the demo it’s OK. And also 			the EC2 security group shouldn’t allow connections to the database from the public internet, just the web servers’s security group
	
	* Then, in a terminal export the following variable:
	`export ANSIBLE_HOST_KEY_CHECKING=False`
	This will allow to the Ansible-playbook command to run without asking 	to add the servers keys
	* Then in the same terminal at the root of the repository  run:
	`ansible-playbook -i ./playbooks/hosts ./playbooks/site.yml -v`
	or inside the *playbooks* folder:
	`ansible-playbook -i hosts site.yml -v`
	
	* 	Wait until the process is over and use the public DNS of the web server(s) to access the Demo app!
	
	
	![](Ansible%20Demo%20App/11584CD6-4F9B-4AEA-B47E-EACB5D11B902.png)


### If you are going to use the Terraform Scripts
	* Install Terraform: [Terraform by HashiCorp](https://www.terraform.io)
	* Install Ansible: [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node)
	* You must have installed and configured the AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
	* Ensure that your AWS User has the proper permissions to create, modify, delete resources
	* In the repo, navigate to the **terraform folder** and run `terraform init`, wait until this finishes successfully and then run `terraform plan`; and if everything is OK, then execute `terraform apply` and respond « yes » to the confirmation. Here you must provide the *vpc_id*, *subnet_id* where the EC2s will be and the *keypair* to connect to them, for example:



	* Wait until the resources are created and then copy the EC2s DNS names from the final output; then go to the *playbooks* folder and edit the **hosts** file like this (only one DBserver should be created, you could create and provision another one, but they won’t work as a cluster):
	
	![](Ansible%20Demo%20App/45B85602-9CB2-452E-9F5E-A6450D2962CB.png)
	* Then you can continue with the rest of the points


### If you’re not using the terraform scripts

If you’re not going to use the Terraform provided scripts to create EC2 instances and security groups, you must take into account:

	* Install Ansible: [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node)
	* You must have installed and configured the AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
	* Ensure that your AWS User has the proper permissions to create, modify, delete resources
	* The Ansible Playbooks are tested against RHEL8 compatible, anything earlier might not work; as well as any Debian or Amazon Linux based OS
	* This AMI: **Red Hat Enterprise Linux 8 (HVM), SSD Volume Type** - ami-087c2c50437d0b80d (64-bit x86) , is the one used; it’s still part of the Free Tier
	* You must configure security groups that allow the communication to ports 80,443 and 3306 for mysql, as well as SSH and create and store the key pair for the EC2 instances 
