import json
  
def gen_ips(file_name):
    ip_array = []
    f = open(file_name, "r")
    ips = f.readlines()
    f.close()
    count = 0
    for line in ips:
        ip = [line.strip()]
        ip_array.append({"name": str(count), "ip": ip})
        count += 1
    return ip_array

path = "auth/server_auth.txt"
ip_list = {"ip_list": gen_ips(path)}
  
# Serializing json 
json_object = json.dumps(ip_list, indent = 4)
  
# Writing to sample.json
with open("ips.json", "w") as outfile:
    outfile.write(json_object)