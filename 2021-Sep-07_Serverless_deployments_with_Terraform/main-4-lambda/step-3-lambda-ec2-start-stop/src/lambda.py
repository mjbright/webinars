
#!/usr/bin/env python3

#import pprint
#pp = pprint.PrettyPrinter(indent=2)

# For json.dumps: prints json more reliably than pprint
import json
import os,sys
import boto3
from   datetime import datetime
#from pathlib import Path

ec2 = None
current_session = None
aws_default_region = 'unset'
#aws_default_region = 'us-west-1'

def get_region(default='us-west-1'):
    aws_default_region = os.getenv('AWS_DEFAULT_REGION')
    #print(f'aws_default_region = "{aws_default_region}"')
    if aws_default_region == None:
        aws_default_region = 'us-west-1'
        print(f'FORCED: aws_default_region = "{aws_default_region}"')
    return aws_default_region

def ec2_client():
    #print(f'aws_default_region = "{aws_default_region}"')
    aws_default_region = get_region()
    #print(f'aws_default_region = "{aws_default_region}"')
    # FOR NOW
    ec2 = boto3.client('ec2', region_name=aws_default_region)
    current_session = boto3.Session(region_name = aws_default_region)
    return (ec2, current_session)

def die(msg):
    print(f"die: {sys.argv[0]} - {msg}")
    sys.exit(1)

def ec2_start(event, context):
    print(f'---- [{datetime.now()}] ---- ec2_start ----')
    print(f'event="{event}"'); print(f'context="{context}"')
    instance=None
    if 'id' in event:
        instance=event['id']
    #CLIENT_IP={request.remote_addr}
    #return return_template_index( f"day{n}.LXF.LFS458.html", f"Day{n}" )
    response = start_instance(aws_default_region, instance)
    return response, 200

def start_instance(region_name, instance):
    (ec2, current_session) = ec2_client()
    #ec2 = boto3.client('ec2', region_name=get_region())
    #print(f'ec2_client="{ec2}"')
    #current_session = boto3.Session(region_name = get_region())
    #print(f'current_session="{current_session}"')
    if instance == None:
        response = get_instances(aws_default_region)
        num_instances=len(response['instances'])
        print(f'Starting all {num_instances} instances ...')
        instance_ids=[]
        for instance in response['instances']:
            instance_ids.append( instance['id'] )

        print(f'ec2.start_instances(InstanceIds={instance_ids})')
        ec2.start_instances(InstanceIds=instance_ids)
        return response

    print(f'Starting instance "{instance}" ...')
    return ec2.start_instances(InstanceIds=[instance])

def ec2_stop(event, context):
    print(f'---- [{datetime.now()}] ---- ec2_stop ----')
    print(f'event="{event}"'); print(f'context="{context}"')
    instance=None
    if 'id' in event:
        instance=event['id']
    response = stop_instance(aws_default_region, instance)
    return response, 200

def stop_instance(region_name, instance):
    (ec2, current_session) = ec2_client()
    #ec2 = boto3.client('ec2', region_name=get_region())
    #print(f'ec2_client="{ec2}"')
    #current_session = boto3.Session(region_name = get_region())
    #print(f'current_session="{current_session}"')
    if instance == None:
        response = get_instances(aws_default_region)
        num_instances=len(response['instances'])
        print(f'Stopping all {num_instances} instances ...')
        instance_ids=[]
        for instance in response['instances']:
            instance_ids.append( instance['id'] )

        print(f'ec2.stop_instances(InstanceIds={instance_ids})')
        ec2.stop_instances(InstanceIds=instance_ids)
        return response

    print(f'Stopping instance "{instance}" ...')
    return ec2.stop_instances(InstanceIds=[instance])

def ec2_describe_all(event, context):
    print(f'---- [{datetime.now()}] ---- ec2_describe_all ----')
    #print('---- ec2_describe_all ----')
    print(f'event="{event}"'); print(f'context="{context}"')

    ec2 = boto3.client('ec2', region_name=get_region())
    current_session = boto3.Session(region_name = get_region())

    response = get_instances(aws_default_region)
    #num_instances=len(response['Reservations'])
    num_instances=len(response['instances'])
    #response = {
    #        'instances': [
    #            {'id': 'i-1', 'state': 'stopped'},
    #            {'id': 'i-2', 'state': 'running'},
    #            ]
    #        }
    print(f'Number of instances seen="{num_instances}"')
    print(f'response="{response}"')
    print(f'type(response)="{type(response)}"')
    return response, 200

def get_instances(region_name):
    (ec2, current_session) = ec2_client()
    response = ec2.describe_instances()
    #print(f'response="{response}"')

    num_instances=len(response['Reservations'])
    running=0
    r=0
    terminating=0
    terminated=0
    stopped=0
    other=0
    instance_info=''

    return_response={
            'instances': []
        }

    for reservation in response['Reservations']:
        r=r+1
        i=0
        for instance in reservation['Instances']:
            i=i+1
            instanceId=instance['InstanceId']
            instanceType=instance['InstanceType']
            launchTime=instance['LaunchTime']
            ip=''
            pubip=''
            if 'PrivateIpAddress' in instance: ip=instance['PrivateIpAddress']
            if 'PublicIpAddress'  in instance: pubip=instance['PublicIpAddress']
            state=instance['State']['Name']
            image=instance['ImageId']

            return_response['instances'].append( { 'id': instanceId, 'state': state, 'pub_ip': pubip } )
    
            showInstance=True
            if state == 'running':
                running+=1
            elif state == 'terminating':
                terminating+=1
            elif state == 'terminated':
                terminated+=1
            elif state == 'stopped':
                stopped+=1
            else:
                other+=1

            #print(f'{region_name}-r[{r}][{i}] {instanceId} {instanceType} {launchTime} {ip} {pubip} {state} {image}')
            if instance_info != '':
                instance_info+='\n'
            instance_info+=f'    - r[{r}][{i}] {instanceId} {instanceType} {launchTime} {ip} {pubip} {state} {image}'


    #print(f'# running={running}/{num_instances}')
    if num_instances > 0:
        print(f'    [running={running} stopped={stopped} terminating={terminating} terminated={terminated} other={other}] / TOTAL={num_instances}')
        print(instance_info)

    response = return_response
    print(f'returning response="{response}"')
    return response


