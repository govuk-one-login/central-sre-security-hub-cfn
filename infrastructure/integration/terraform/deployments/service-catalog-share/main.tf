# can be amended to share woth OU when ready
# no dynamic lookup for portfolio id so hardcoded :(

resource "aws_servicecatalog_portfolio_share" "compute" {
  principal_id = "842766856468" # di-devplatform-development
  portfolio_id = "port-hh44eiilsucds"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "encryption" {
  principal_id = "842766856468" # di-devplatform-development
  portfolio_id = "port-cpfdvkdctommo"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "messaging" {
  principal_id = "842766856468" # di-devplatform-development
  portfolio_id = "port-i66rmt4bkpj4i"
  type         = "ACCOUNT"
}

resource "aws_servicecatalog_portfolio_share" "storage" {
  principal_id = "842766856468" # di-devplatform-development
  portfolio_id = "port-xu3knezauqlwk"
  type         = "ACCOUNT"
}