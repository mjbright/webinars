
# Groups: ----------------------------------------------------------

resource "aws_iam_group" "ec2-start-stop-group" {
  name = "ec2-start-stop-group"
}

resource "aws_iam_policy_attachment" "ec2-start-stop-group-attach" {
  name       = "ec2-start-stop-group-attach"
  groups     = [aws_iam_group.ec2-start-stop-group.name]
  policy_arn = aws_iam_policy.ec2-start-stop-policy.arn
}

# Policies: --------------------------------------------------------

resource "aws_iam_policy" "ec2-start-stop-policy" {
  name        = "ec2-start-stop-policy"
  description = "A ec2-start-stop policy"

  policy = templatefile("ec2-start-stop-policy.json", { tag_key = "env", tag_value = "start-stop" })
}

# Roles: -----------------------------------------------------------

# Students: --------------------------------------------------------

resource "aws_iam_user" "ec2-start-stop" {
    name = "ec2-start-stop-user"
}

resource "aws_iam_group_membership" "ec2-start-stop-group-users" {
  name = "ec2-start-stop-group-users"
  ##users = [
  ##]
  users = [ aws_iam_user.ec2-start-stop.name ]
  group = aws_iam_group.ec2-start-stop-group.name
}

# User Access Keys: ------------------------------------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
resource "aws_iam_access_key" "ec2-start-stop-key" {
    user    = aws_iam_user.ec2-start-stop.name
    #OPTIONAL: pgp_key = "keybase:some_person_that_exists"
}

# Outputs: ---------------------------------------------------------

output access_key {
    # Temporary keys: yes we really want to output this data ... so set sensitive to false
    sensitive = true
    value = aws_iam_access_key.ec2-start-stop-key.id
}

output secret_access_key {
    # Temporary keys: yes we really want to output this data ... so set sensitive to false
    sensitive = true
    value = aws_iam_access_key.ec2-start-stop-key.secret
}


