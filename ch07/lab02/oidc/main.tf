# GitHub OIDC Provider를 AWS에 등록,  AWS가 GitHub에서 발급한 JWT 토큰을 신뢰할 수 있게 하는 리소스
resource "aws_iam_openid_connect_provider" "this" {
  url             = local.iamoidcp.url
  client_id_list  = local.iamoidcp.client_id_list
  thumbprint_list = local.iamoidcp.thumbprint_list

  tags = {
    Name = "${local.namespace}-iamoidcp-${local.iamoidcp.name}"
  }
}

# GitHub Actions가 assume할 IAM Role, 누가 이 Role을 사용할 수 있는가를 정의
resource "aws_iam_role" "this" {
  name = "${local.namespace}-iamrole-${local.iamrole.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.this.arn
      }

      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${local.github_repo}:*"
        }
      }
    }]
  })

  tags = {
    Name = "${local.namespace}-iamrole-${local.iamrole.name}"
  }
}

# Role에 권한을 부여
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = local.iamrole.policy_arn
}