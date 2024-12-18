import urllib3


class ErrorHandler:
    def error():
        return "Something went wrong"


def lambda_handler(event, context): 
    http = urllib3.PoolManager()
    user_input = None
    if event.get("queryStringParameters"):
        user_input = event.get("queryStringParameters").get("user_input")
    else:
        user_input = event.get("user_input")
    try:
        r = http.request('GET', 
        'http://api.marketstack.com/v1/eod?' +
        'access_key=1993a5a661a25f23c46c92e886a6294b&' +
        f'symbols={user_input}')
    except:
        return ErrorHandler.error()
    return r.data

