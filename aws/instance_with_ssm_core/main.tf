resource "aws_iam_role" "ssm_core" {
  name_prefix        = "ssm-core-"
  assume_role_policy = data.aws_iam_policy_document.ssm_core_assume_role_policy.json
}

data "aws_iam_policy_document" "ssm_core_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_core.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_core" {
  role = aws_iam_role.ssm_core.name
}

data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "ssm_core" {
  ami                    = data.aws_ssm_parameter.amazon_linux.value
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.ssm_core.name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = var.tags
}
