// You don't really need this unless you want a proper database, this will make your sites quicker

//module "mysql-db" {
//  source = "GoogleCloudPlatform/sql-db/google"
//
//  name = "${var.corporate-tag}-db-mysql-1"
//  region = var.hq-region
//
//  tier = "db-n1-standard-1"
//  database_version = "MYSQL_5_7"
//  db_charset = "utf8"
//  db_collation = "utf8_general_ci"
//
//  user_name = "db_admin"
//  user_password = "PutSomethingSuperSecretHere"
//
//  ip_configuration = {
//    ipv4_enabled = true
//    require_ssl = false
//    authorized_networks = [
//      {
//        name = module.my-server.server_name
//        value = "${module.my-server.server_ip}/32"
//      },
//      {
//        name = "my_home"
//        value = "${var.home_ip}/32"
//      },
//      {
//        name = "my_office"
//        value = "${var.office_01_ip}/32"
//      },
//    ]
//  }
//
//  location_preference = {
//    zone = "${var.hq-region}-${var.main-zone}"
//  }
//
//  backup_configuration = {
//    enabled = true
//    start_time = "09:00"
//  }
//
//  maintenance_window = {
//    day = 7
//    # Sunday
//    hour = 10
//    # 2am
//  }
//}
//
