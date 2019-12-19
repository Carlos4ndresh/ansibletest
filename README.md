# Ansible Demo App
This is a small app written in Flask (1.11.x/Python 3.x) using MySQL 8 as a data store. Front end uses HTML+Jinja2+Bootstrap4

## Prerequisites
- Terraform
- Ansible
- Python 3.x
- AWS CLI
-EC2 instances with RHEL8 or compatible OS (this won’t work on Debian or Amazon Linux Based Oses)

## Deployment of the demo
- First clone this repo to your local environment
- Edit the **hosts** file inside the *playbooks* folder
	
	~~~~
	[webservers]
	ec2-34-220-203-40.us-west-2.compute.amazonaws.com
	ec2-52-34-84-33.us-west-2.compute.amazonaws.com

	[dbservers]
	ec2-34-219-92-44.us-west-2.compute.amazonaws.com
   	~~~~~


- There add the web servers (could be one or many) and the db-server you will use to deploy (only one DBserver should be created, you 	could create and provision another one, but they won’t work as a cluster)

- Then, still inside the *playbooks* folder, go to the *global_vars* folder and then the **all.yml** file and change:
		
	- The location of the ansible_ssh_private_key, to the location of your private key, that will be used to connect to the servers in the inventory

	- Change the SQLALCHEMY_DATABASE_URI variable in the part corresponding to the DBServer

	- If you would like to change the mysqlpassword you could do it here, and then in the **dbserver.yml** file in the same folder
	
	~~~~~
	# Change here to your own EC2s private Key
	ansible_ssh_private_key_file: /Users/cherrera/Downloads/ansibletest.pem
	nginx_port: 80
	# GitHub Repository
	repository: https://github.com/Carlos4ndresh/ansibletest.git
	## Change Here the portion between the "@"" for the DNS name of the DBServer and the ":"
	SQLALCHEMY_DATABASE_URI: mysql+pymysql://myuser:mypwd@ec2-34-219-92-44.us-west-2.compute.amazonaws.com:3306/mydb
	~~~~~~
		
	It’s insecure, but for the effects of the demo it’s OK. And, the EC2 security group shouldn’t allow connections to the database from the public internet, just the web servers’s security group
	
- Afterwards, in a terminal export the following variable:
	`export ANSIBLE_HOST_KEY_CHECKING=False`
	This will allow to the Ansible-playbook command to run without asking 	to add the servers keys
- In the same terminal at the root of the repository  run:
	`ansible-playbook -i ./playbooks/hosts ./playbooks/site.yml -v`
	or inside the *playbooks* folder:
	`ansible-playbook -i hosts site.yml -v`
	
- Wait until the process is over(can take up to 5 minutes, even more if you are provisioning more than 3 servers), and use the public DNS of the web server(s) to access the Demo app!
	
	
### If you are going to use the Terraform Scripts
- Install Terraform: [Terraform by HashiCorp](https://www.terraform.io)
- Install Ansible: [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node)
- You must have installed and configured the AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- Ensure that your AWS User has the proper permissions to create, modify, delete resources
- In the repo, navigate to the **terraform folder** and run `terraform init`, wait until this finishes successfully and then run `terraform plan`; and if everything is OK, then execute `terraform apply` and respond « yes » to the confirmation. Here you must provide the *vpc_id*, *subnet_id* (With internet access, DNS and DHCP enabled) where the EC2s will be and the *keypair* to connect to them, for example:

	~~~~~
	terraform plan
	var.keypair_name
	Enter a value: ansibletest

	var.subnet_id
	Enter a value: subnet-1ffbd245

	var.vpc_id
	Enter a value: vpc-1310dd6b
	~~~~~~

	~~~~~~
	cherrera@MacBook-Pro-de-Carlos-Andres terraform % terraform apply 
	var.keypair_name
	Enter a value: ansibletest

	var.subnet_id
	Enter a value: subnet-1ffbd245

	var.vpc_id
	Enter a value: vpc-1310dd6b
	~~~~~~~


- Wait until the resources are created and then copy the EC2s DNS names from the final output; then go to the *playbooks* folder and edit the **hosts** file like this (only one DBserver should be created, you could create and provision another one, but they won’t work as a cluster):
	
	~~~~~
	Outputs:

	dbserver = ec2-34-219-92-44.us-west-2.compute.amazonaws.com
	webservers = [
	"ec2-34-220-203-40.us-west-2.compute.amazonaws.com",
	"ec2-52-34-84-33.us-west-2.compute.amazonaws.com",
	]

	~~~~~

- After that, you can continue with the rest of the points


### If you’re not using the terraform scripts

If you’re not going to use the Terraform provided scripts to create EC2 instances and security groups, you must take into account:

- Install Ansible: [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node)
- You must have installed and configured the AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- Ensure that your AWS User has the proper permissions to create, modify, delete resources
- The Ansible Playbooks are tested against RHEL8 compatible, anything earlier might not work; as well as any Debian or Amazon Linux based OS
- This AMI: **Red Hat Enterprise Linux 8 (HVM), SSD Volume Type** - ami-087c2c50437d0b80d (64-bit x86) , is the one used; it’s still part of the Free Tier
- You must configure security groups that allow the communication to ports 80,443 and 3306 for mysql, as well as SSH and create and store the key pair for the EC2 instances 
