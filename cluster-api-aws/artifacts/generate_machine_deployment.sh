#!/usr/local/bin/python3
import sys, yaml, os, time

def get_subnets(stream):
  subnets=[]
  try:
    parsed = yaml.safe_load(stream)
    for entry in parsed['spec']['networkSpec']['subnets']:
      if not entry['isPublic']:
        subnets.append(entry['id'])
  except yaml.YAMLError as exc:
    print(exc)
  except TypeError as exc:
    print(exc)
  return subnets

def gen_machinpool_resource_yaml(aws_machine_template, subnet):
  try:
    parsed = yaml.safe_load(aws_machine_template)

    for resource in parsed:
      parsed[resource]['AWSMachineTemplate']['spec']['subnet']['id']=subnetd
  except yaml.YAMLError as exc:
    print(exc)
  except TypeError as exc:
    print(exc)

  return parsed

def main(argv):
  stream = os.popen('kubectl get awscluster -n {1} {0} -o yaml'.format(sys.argv[1],sys.argv[2]))
  subnets = get_subnets(stream)

  for subnet in subnets:
    mds = gen_machinpool_resource_yaml(open('md.raw.yaml', 'r'), subnet)
  
    mdf = open('mds-{0}.yaml'.format(subnet), 'a')
    for md in mds:
      for resource in mds[md]:
        mdf.write('---\n')
        mdf.write(yaml.dumd(mds[md][resource]))
  
    mdf.close()
    os.system('kubectl apply -n {0} -f mds-{1}.yaml'.format(sys.argv[2]), subnet)

if __name__ == "__main__":
  main(sys.argv[1:])
