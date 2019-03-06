## Automating deployment on AWS EC2 instance using bash script 

## About
A script that helps you deploy a project from github, install and setup all dependencies and runs the application in the background using pm2.

#### Dependencies

1. These project uses [`pm2`](http://pm2.keymetrics.io/) for running the application in background process
2.  [`nginx`](https://www.nginx.com/) for reverse proxy
3.  [`Certbot`](https://github.com/certbot/certbot) for enabling letEncrypt SSL certificates

#### Security Group
>- When creating your instance set the security group to the following below:
>- set `type`:`HTTP` to `source` of `Anywhere`
>- set `type`:`HTTPS` to `source` of `Anywhere`
>- set `type`:`Custom TCP` to `port`:8080 of `source`: `MY IP`
>- set `type`:`SSH` to `source` of `MY IP`

### Setup environment varibles

>- To setup your environment variables used the .env.sample as a guide
>- export domainName='your domain name'
>- export domainName2='www.your domain name'
>- export email='your email'
>- export repo='your project github repo'

### Setup Route 53 on AWS

For your ip address to map to your domain, you need to configure your Route 53 with the ip address of your instance
use the dns provided by Rout 53 on your domain name dns settings.


#### Instructions


You can get the script running in the following way:

1. Clone the repository and cd into it
   
	  ```
    git clone https://github.com/ekpangmichael/automate-deployment.git
    cd automate-deployment
    ```
2. To run the script, run
    ```
    sudo bash automate.sh
    ```

