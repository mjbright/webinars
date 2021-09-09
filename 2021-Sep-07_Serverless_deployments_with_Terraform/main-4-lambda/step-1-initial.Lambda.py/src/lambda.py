import json

import sys, os

def lambda_handler(event, context):
    print('\n---- environment variables: -------------')
    for var in os.environ:
        print(f'{var:30s}: {os.environ[var]}')

    print('\n---- received event fields: -------------')
    print(json.dumps(event, indent=2))

    print('\n---- runtime info: ----------------------')
    print(f'[Python{sys.version_info.major}.{sys.version_info.minor}]: Entered into method:lambda_hander')

    #print(f'Running in context: {context}')
    print()
    return "Returning from method:lambda_hander"

def lambda_handler2(event, context):
    print('---- environment variables: -------------')
    for var in os.environ:
        print(f'{var:30s}: {os.environ[var]}')

    print('\n---- received event fields: -------------')
    print(json.dumps(event, indent=2))

    print('\n---- runtime info: ----------------------')
    print(f'[Python{sys.version_info.major}.{sys.version_info.minor}]: Entered into method:lambda_hander2')

    #print(f'Running in context: {context}')
    print()
    return "Returning from method:lambda_hander2"


