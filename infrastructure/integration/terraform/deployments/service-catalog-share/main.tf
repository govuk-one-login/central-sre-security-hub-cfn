# can be amended to share woth OU when ready
# no dynamic lookup for portfolio id so hardcoded :(

resource "aws_servicecatalog_portfolio_share" "compute" {
  for_each = toset(local.account_shares)

  principal_id        = each.value
  portfolio_id        = "port-se3ntmvk63ir6"
  type                = "ACCOUNT"
  wait_for_acceptance = false

  timeouts {
    read = "3m"
  }

}

resource "aws_servicecatalog_portfolio_share" "encryption" {
  for_each = toset(local.account_shares)

  principal_id        = each.value
  portfolio_id        = "port-7ywkeavcrur6u"
  type                = "ACCOUNT"
  wait_for_acceptance = false

  timeouts {
    read = "3m"
  }
}

resource "aws_servicecatalog_portfolio_share" "messaging" {
  for_each = toset(local.account_shares)

  principal_id        = each.value
  portfolio_id        = "port-p3jhpq3k4c65w"
  type                = "ACCOUNT"
  wait_for_acceptance = false

  timeouts {
    read = "3m"
  }
}

resource "aws_servicecatalog_portfolio_share" "storage" {
  for_each = toset(local.account_shares)

  principal_id        = each.value
  portfolio_id        = "port-g5sj6kxctmpza"
  type                = "ACCOUNT"
  wait_for_acceptance = false

  timeouts {
    read = "3m"
  }

}
