# Spit out each managed wordpress server in this server map
output "wp_server_map" {
  value = {
    "us-central1-a" = [
      module.my-server.server_name,
    ]
  }
}

output "server_addresses" {
  value = {
    "module.my-server.server_ip"  = module.my-server.server_location
  }
}

output "server_netmap" {
  value = {
    "module.my-server.server_name"  = module.my-server.server_ip
  }
}

//output "sql_instance_address" {
//  value = module.mysql-db.instance_address
//}

