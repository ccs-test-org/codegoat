data "aws_iam_policy_document" "example-policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "admin-role" {
  name                = "${var.environment}_admin_role"
  assume_role_policy  = data.aws_iam_policy_document.example-policy.json # (not shown)
  managed_policy_arns = []
  tags = {
    yor_trace = "85c044ae-9f7b-49b6-ac72-7e1f6a51d4c3"
  }
}
