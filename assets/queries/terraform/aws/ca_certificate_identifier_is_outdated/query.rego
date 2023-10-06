package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.ca_cert_identifier != ['rds-ca-rsa4096-g1', 'rds-ca-ecc384-g1']

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].ca_cert_identifier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_instance.ca_cert_identifier' should be 'rds-ca-rsa4096-g1' or 'rds-ca-ecc384-g1'",
		"keyActualValue": sprintf("'aws_db_instance.ca_cert_identifier' is '%s'", [resource.ca_cert_identifier]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "ca_cert_identifier"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "ca_cert_identifier")
	module[keyToCheck] != ['rds-ca-rsa4096-g1', 'rds-ca-ecc384-g1']

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ca_cert_identifier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ca_cert_identifier' should be 'rds-ca-rsa4096-g1' or 'rds-ca-ecc384-g1'",
		"keyActualValue": sprintf("'ca_cert_identifier' is '%s'", [module.ca_cert_identifier]),
		"searchLine": common_lib.build_search_line(["module", name, "ca_cert_identifier"], []),
	}
}
