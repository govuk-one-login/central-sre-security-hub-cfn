from .client import Client

class ServiceCatalog():
  
  def __init__(self, client: Client) -> None:
    self.service_catalog_client = client.client('servicecatalog')