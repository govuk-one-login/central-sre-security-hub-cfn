import sys
from lib import Client

from aws_lambda_powertools.logging.logger import Logger

logger: Logger = Logger(service='service-catalog-import', level='INFO') 

def lambda_handler(event, context) -> None:
    """Entry point for the lambda.

    :param event: The triggering event
    :type event: AWS event
    :param context: The context of the event trigger
    :type context: AWS event context
    """
    logger.info('Triggered by event', extra={
            'event': event
        })
    
    cient = Client()

# Local testing entry point
if __name__ == "__main__":
    sys.exit(lambda_handler(event={}, context={}))