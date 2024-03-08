# can be amended to share woth OU when ready
# no dynamic lookup for portfolio id so hardcoded :(

resource "aws_servicecatalog_portfolio_share" "compute" {
  for_each = toset(local.account_shares)

  principal_id = each.value
  portfolio_id = "port-hh44eiilsucds"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "encryption" {
  for_each = toset(local.account_shares)

  principal_id = each.value
  portfolio_id = "port-cpfdvkdctommo"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "messaging" {
  for_each = toset(local.account_shares)

  principal_id = each.value
  portfolio_id = "port-i66rmt4bkpj4i"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "storage" {
  for_each = toset(local.account_shares)
  
  principal_id = each.value
  portfolio_id = "port-xu3knezauqlwk"
  type         = "ACCOUNT"
}
