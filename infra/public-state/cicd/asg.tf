# # Launch Template & UserData
# resource "aws_launch_template" "asg_lt" {
#   name_prefix   = "${var.tag_header}-"
#   image_id      = var.ami_id
#   instance_type = "t3.small"
#   key_name      = var.key_name
# }
