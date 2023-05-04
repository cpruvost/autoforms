# output "db_url" {
#   value = data.oci_database_databases.databases.databases[0]
# }

output "db_url" {
  value = data.oci_database_pluggable_databases.test_pluggable_databases.pluggable_databases[0].connection_strings
}