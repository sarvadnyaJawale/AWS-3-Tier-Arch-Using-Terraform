resource "aws_launch_template" "template" {
  name_prefix     = "tf-asg-lt"
  image_id        =  var.ami_id
  instance_type   =  var.instance_type
  key_name        =  var.key
  user_data       =  base64encode(<<-EOF
    #!/bin/bash

    # Update the system
    sudo apt-get update -y

    # Install Apache web server
    sudo apt-get install -y apache2

    # Start Apache web server
    sudo systemctl start apache2

    # Enable Apache to start at boot
    sudo systemctl enable apache2

    # Create index.html file with your custom HTML
    sudo bash -c 'cat > /var/www/html/index.html << EOL
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>A Basic HTML5 Template</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="css/styles.css?v=1.0" />
      </head>
      <body>
        <div class="wrapper">
          <div class="container">
            <h1>Welcome! An Apache web server has been started successfully.</h1>
            <h2>Achintha Bandaranaike</h2>
          </div>
        </div>
      </body>
      <style>
        body {
          background-color: #34333d;
          display: flex;
          align-items: center;
          justify-content: center;
          font-family: Inter;
          padding-top: 128px;
        }
        .container {
          box-sizing: border-box;
          width: 741px;
          height: 449px;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: flex-start;
          padding: 48px 48px 48px 48px;
          box-shadow: 0px 1px 32px 11px rgba(38, 37, 44, 0.49);
          background-color: #5d5b6b;
          overflow: hidden;
          align-content: flex-start;
          flex-wrap: nowrap;
          gap: 24;
          border-radius: 24px;
        }
        .container h1 {
          flex-shrink: 0;
          width: 100%;
          height: auto;
          position: relative;
          color: #ffffff;
          line-height: 1.2;
          font-size: 40px;
        }
        .container p {
          position: relative;
          color: #ffffff;
          line-height: 1.2;
          font-size: 18px;
        }
      </style>
    </html>
    EOL'
    EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_vpc_http_ssh]
  }
}

#autoscaling in public subnet
resource "aws_autoscaling_group" "public_autoscale" { 
  name                  = "tf-autoscaling-group-in-pubsub"  
  desired_capacity      = 2
  max_size              = 4
  min_size              = 1
  health_check_type     = "EC2"
  termination_policies  = ["OldestInstance"]
  vpc_zone_identifier   = var.public_subnets

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}
#autoscaling in private subnet
resource "aws_autoscaling_group" "private_autoscale" { 
  name                  = "tf-autoscaling-group-prisub"  
  desired_capacity      = 2
  max_size              = 4
  min_size              = 1
  health_check_type     = "EC2"
  termination_policies  = ["OldestInstance"]
  vpc_zone_identifier   = var.private_subnets

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}